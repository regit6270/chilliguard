from google.cloud import firestore
from app.core.firebase import get_firestore_client
import logging

logger = logging.getLogger(__name__)

class FirestoreDB:
    """Firestore database wrapper"""

    def __init__(self):
        self.db = None

    def init_app(self, app):
        """Initialize Firestore with Flask app"""
        try:
            self.db = get_firestore_client()
            logger.info('Firestore database initialized')
        except Exception as e:
            logger.error(f'Failed to initialize Firestore: {str(e)}')
            raise

    def collection(self, collection_name):
        """Get collection reference"""
        return self.db.collection(collection_name)

    def document(self, collection_name, document_id):
        """Get document reference"""
        return self.db.collection(collection_name).document(document_id)

    def get_document(self, collection_name, document_id):
        """Get document data"""
        try:
            doc_ref = self.document(collection_name, document_id)
            doc = doc_ref.get()
            if doc.exists:
                data = doc.to_dict()
                data['id'] = doc.id
                return data
            return None
        except Exception as e:
            logger.error(f'Failed to get document: {str(e)}')
            return None

    def create_document(self, collection_name, data, document_id=None):
        """Create new document"""
        try:
            if document_id:
                doc_ref = self.document(collection_name, document_id)
                doc_ref.set(data)
                return document_id
            else:
                doc_ref = self.collection(collection_name).document()
                doc_ref.set(data)
                return doc_ref.id
        except Exception as e:
            logger.error(f'Failed to create document: {str(e)}')
            raise

    def update_document(self, collection_name, document_id, data):
        """Update existing document"""
        try:
            doc_ref = self.document(collection_name, document_id)
            doc_ref.update(data)
            return True
        except Exception as e:
            logger.error(f'Failed to update document: {str(e)}')
            return False

    def delete_document(self, collection_name, document_id):
        """Delete document"""
        try:
            doc_ref = self.document(collection_name, document_id)
            doc_ref.delete()
            return True
        except Exception as e:
            logger.error(f'Failed to delete document: {str(e)}')
            return False

    def query_collection(self, collection_name, filters=None, order_by=None, limit=None):
        """Query collection with filters"""
        try:
            query = self.collection(collection_name)

            if filters:
                for field, operator, value in filters:
                    query = query.where(field, operator, value)

            if order_by:
                for field, direction in order_by:
                    query = query.order_by(field, direction=direction)

            if limit:
                query = query.limit(limit)

            docs = query.stream()
            results = []
            for doc in docs:
                data = doc.to_dict()
                data['id'] = doc.id
                results.append(data)

            return results
        except Exception as e:
            logger.error(f'Failed to query collection: {str(e)}')
            return []

# Global database instance
db = FirestoreDB()

def init_db(app):
    """Initialize database with Flask app"""
    db.init_app(app)
