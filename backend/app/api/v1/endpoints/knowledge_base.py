"""
Knowledge Base API Endpoints
Provides educational content, articles, disease information, and FAQs
"""
from datetime import datetime
from typing import Dict, List
from flask import Blueprint, request, jsonify
import logging

# Initialize blueprint
knowledge_base_bp = Blueprint('knowledge_base', __name__, url_prefix='/api/v1')

# Configure logging
logger = logging.getLogger(__name__)

# In-memory knowledge base (move to Firestore in production)
KNOWLEDGE_BASE = {
    "articles": [
        {
            "article_id": "art_001",
            "title": "Understanding Chilli Leaf Spot Disease",
            "title_hi": "मिर्च पत्ती धब्बा रोग को समझना",
            "category": "diseases",
            "content": "Leaf spot is one of the most common diseases affecting chilli crops...",
            "content_hi": "पत्ती धब्बा मिर्च की फसलों को प्रभावित करने वाली सबसे आम बीमारियों में से एक है...",
            "author": "ICAR Research",
            "image_url": "https://storage.googleapis.com/chilliguard/articles/leaf-spot.jpg",
            "tags": ["leaf-spot", "disease", "prevention"],
            "reading_time": "5 min",
            "published_date": "2024-01-15",
            "language": "en"
        },
        {
            "article_id": "art_002",
            "title": "Optimal Soil pH for Chilli Cultivation",
            "title_hi": "मिर्च की खेती के लिए उपयुक्त मृदा pH",
            "category": "soil",
            "content": "Maintaining proper soil pH is crucial for chilli growth...",
            "content_hi": "मिर्च के विकास के लिए उचित मृदा pH बनाए रखना महत्वपूर्ण है...",
            "author": "Agricultural Extension Services",
            "tags": ["soil-health", "pH", "nutrients"],
            "reading_time": "4 min",
            "published_date": "2024-02-10",
            "language": "en"
        },
        {
            "article_id": "art_003",
            "title": "Organic Pest Control Methods",
            "title_hi": "जैविक कीट नियंत्रण विधियाँ",
            "category": "pest-control",
            "content": "Learn natural pest control without harmful chemicals...",
            "content_hi": "हानिकारक रसायनों के बिना प्राकृतिक कीट नियंत्रण सीखें...",
            "author": "Organic Farming Council",
            "tags": ["organic", "pest-control", "sustainable"],
            "reading_time": "7 min",
            "published_date": "2024-03-05",
            "language": "en"
        }
    ],
    "diseases": [
        {
            "disease_id": "dis_001",
            "name": "Anthracnose",
            "name_hi": "एन्थ्रेक्नोज",
            "symptoms": "Dark, sunken lesions on fruits and leaves",
            "symptoms_hi": "फल और पत्तियों पर गहरे, धंसे हुए घाव",
            "causes": "Fungal infection (Colletotrichum species)",
            "prevention": "Remove infected plants, improve air circulation, avoid overhead irrigation",
            "treatment_chemical": "Apply copper-based fungicides",
            "treatment_organic": "Neem oil spray, bio-fungicides",
            "images": ["anthracnose1.jpg", "anthracnose2.jpg"]
        },
        {
            "disease_id": "dis_002",
            "name": "Powdery Mildew",
            "name_hi": "चूर्णिल आसिता",
            "symptoms": "White powdery coating on leaves",
            "symptoms_hi": "पत्तियों पर सफ़ेद पाउडर जैसी परत",
            "causes": "Fungal infection (Leveillula taurica)",
            "prevention": "Maintain low humidity, adequate spacing",
            "treatment_chemical": "Sulfur-based fungicides",
            "treatment_organic": "Baking soda solution, milk spray",
            "images": ["powdery-mildew1.jpg"]
        }
    ],
    "faqs": [
        {
            "question": "When should I apply the first fertilizer dose?",
            "question_hi": "मुझे पहली खाद की खुराक कब लगानी चाहिए?",
            "answer": "Apply first dose 15-20 days after transplanting",
            "answer_hi": "रोपण के 15-20 दिन बाद पहली खुराक लगाएं",
            "category": "fertilization"
        },
        {
            "question": "How do I identify powdery mildew early?",
            "question_hi": "मैं चूर्णिल आसिता को जल्दी कैसे पहचानूं?",
            "answer": "Look for white powdery spots on leaf surfaces",
            "answer_hi": "पत्ती की सतह पर सफ़ेद पाउडर जैसे धब्बे देखें",
            "category": "disease-identification"
        }
    ]
}


@knowledge_base_bp.route('/articles', methods=['GET'])
def list_articles():
    """
    List knowledge base articles with optional filtering
    Query params: category, language, limit
    """
    try:
        category = request.args.get('category')
        language = request.args.get('language', 'en')
        limit = int(request.args.get('limit', 20))

        articles = KNOWLEDGE_BASE['articles']

        # Filter by category
        if category:
            articles = [a for a in articles if a['category'] == category]

        # Filter by language
        articles = [a for a in articles if a.get('language', 'en') == language]

        # Limit results
        articles = articles[:limit]

        # Format response based on language
        formatted_articles = []
        for article in articles:
            formatted = {
                'article_id': article['article_id'],
                'title': article.get(f'title_{language}', article['title']),
                'category': article['category'],
                'author': article['author'],
                'reading_time': article['reading_time'],
                'published_date': article['published_date'],
                'image_url': article.get('image_url'),
                'tags': article['tags']
            }
            formatted_articles.append(formatted)

        return jsonify({
            'status': 'success',
            'count': len(formatted_articles),
            'articles': formatted_articles
        }), 200

    except Exception as e:
        logger.error(f"Error listing articles: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to fetch articles'
        }), 500


@knowledge_base_bp.route('/articles/<article_id>', methods=['GET'])
def get_article(article_id: str):
    """Get detailed article by ID"""
    try:
        language = request.args.get('language', 'en')

        # Find article
        article = next(
            (a for a in KNOWLEDGE_BASE['articles'] if a['article_id'] == article_id),
            None
        )

        if not article:
            return jsonify({
                'status': 'error',
                'message': 'Article not found'
            }), 404

        # Format with language
        response = {
            'article_id': article['article_id'],
            'title': article.get(f'title_{language}', article['title']),
            'content': article.get(f'content_{language}', article['content']),
            'category': article['category'],
            'author': article['author'],
            'reading_time': article['reading_time'],
            'published_date': article['published_date'],
            'image_url': article.get('image_url'),
            'tags': article['tags']
        }

        return jsonify({
            'status': 'success',
            'article': response
        }), 200

    except Exception as e:
        logger.error(f"Error fetching article: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to fetch article details'
        }), 500


@knowledge_base_bp.route('/articles/search', methods=['GET'])
def search_articles():
    """
    Search articles by keyword
    Query params: q (query string), language
    """
    try:
        query = request.args.get('q', '').lower()
        language = request.args.get('language', 'en')

        if not query:
            return jsonify({
                'status': 'error',
                'message': 'Search query required'
            }), 400

        # Simple keyword search in title and tags
        results = []
        for article in KNOWLEDGE_BASE['articles']:
            title = article.get(f'title_{language}', article['title']).lower()
            tags = ' '.join(article['tags']).lower()

            if query in title or query in tags:
                results.append({
                    'article_id': article['article_id'],
                    'title': article.get(f'title_{language}', article['title']),
                    'category': article['category'],
                    'reading_time': article['reading_time'],
                    'relevance': 'high' if query in title else 'medium'
                })

        return jsonify({
            'status': 'success',
            'query': query,
            'count': len(results),
            'results': results
        }), 200

    except Exception as e:
        logger.error(f"Error searching articles: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Search failed'
        }), 500


@knowledge_base_bp.route('/diseases', methods=['GET'])
def list_diseases():
    """Get disease encyclopedia"""
    try:
        language = request.args.get('language', 'en')

        diseases = []
        for disease in KNOWLEDGE_BASE['diseases']:
            diseases.append({
                'disease_id': disease['disease_id'],
                'name': disease.get(f'name_{language}', disease['name']),
                'symptoms': disease.get(f'symptoms_{language}', disease['symptoms']),
                'prevention': disease['prevention'],
                'treatment_organic': disease['treatment_organic']
            })

        return jsonify({
            'status': 'success',
            'count': len(diseases),
            'diseases': diseases
        }), 200

    except Exception as e:
        logger.error(f"Error listing diseases: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to fetch diseases'
        }), 500


@knowledge_base_bp.route('/diseases/<disease_id>', methods=['GET'])
def get_disease_details(disease_id: str):
    """Get detailed disease information"""
    try:
        language = request.args.get('language', 'en')

        disease = next(
            (d for d in KNOWLEDGE_BASE['diseases'] if d['disease_id'] == disease_id),
            None
        )

        if not disease:
            return jsonify({
                'status': 'error',
                'message': 'Disease not found'
            }), 404

        response = {
            'disease_id': disease['disease_id'],
            'name': disease.get(f'name_{language}', disease['name']),
            'symptoms': disease.get(f'symptoms_{language}', disease['symptoms']),
            'causes': disease['causes'],
            'prevention': disease['prevention'],
            'treatment_chemical': disease['treatment_chemical'],
            'treatment_organic': disease['treatment_organic'],
            'images': disease['images']
        }

        return jsonify({
            'status': 'success',
            'disease': response
        }), 200

    except Exception as e:
        logger.error(f"Error fetching disease: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to fetch disease details'
        }), 500


@knowledge_base_bp.route('/faqs', methods=['GET'])
def list_faqs():
    """Get frequently asked questions"""
    try:
        language = request.args.get('language', 'en')
        category = request.args.get('category')

        faqs = KNOWLEDGE_BASE['faqs']

        # Filter by category
        if category:
            faqs = [f for f in faqs if f['category'] == category]

        formatted_faqs = []
        for faq in faqs:
            formatted_faqs.append({
                'question': faq.get(f'question_{language}', faq['question']),
                'answer': faq.get(f'answer_{language}', faq['answer']),
                'category': faq['category']
            })

        return jsonify({
            'status': 'success',
            'count': len(formatted_faqs),
            'faqs': formatted_faqs
        }), 200

    except Exception as e:
        logger.error(f"Error fetching FAQs: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to fetch FAQs'
        }), 500


@knowledge_base_bp.route('/recommendations', methods=['POST'])
def get_recommendations():
    """
    Get personalized article recommendations based on farmer activity
    Request body: {
        "farmer_id": "string",
        "recent_diseases": ["leaf-spot", "powdery-mildew"],
        "recent_issues": ["low-nitrogen"]
    }
    """
    try:
        data = request.get_json()
        recent_diseases = data.get('recent_diseases', [])
        recent_issues = data.get('recent_issues', [])
        language = data.get('language', 'en')

        # Simple tag-based recommendation
        recommendations = []
        all_tags = recent_diseases + recent_issues

        for article in KNOWLEDGE_BASE['articles']:
            # Check if article tags match user's recent activity
            matching_tags = set(article['tags']) & set(all_tags)
            if matching_tags:
                recommendations.append({
                    'article_id': article['article_id'],
                    'title': article.get(f'title_{language}', article['title']),
                    'category': article['category'],
                    'relevance_reason': f"Related to: {', '.join(matching_tags)}",
                    'reading_time': article['reading_time']
                })

        # Limit to top 5
        recommendations = recommendations[:5]

        return jsonify({
            'status': 'success',
            'count': len(recommendations),
            'recommendations': recommendations
        }), 200

    except Exception as e:
        logger.error(f"Error generating recommendations: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to generate recommendations'
        }), 500
