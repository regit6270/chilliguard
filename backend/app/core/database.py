from __future__ import annotations

import logging
from typing import Any, List, Optional, Sequence, Tuple, TYPE_CHECKING, cast

from google.cloud import firestore  # type: ignore[import-untyped]
from app.core.firebase import get_firestore_client

if TYPE_CHECKING:  # pragma: no cover
    from flask import Flask

logger = logging.getLogger(__name__)


class FirestoreDB:
    """Firestore database wrapper"""

    def __init__(self) -> None:
        self.db: Optional[firestore.Client] = None

    def init_app(self, _: "Flask") -> None:
        """Initialize Firestore with Flask app"""
        try:
            self.db = get_firestore_client()
            logger.info('Firestore database initialized')
        except Exception as e:  # pylint: disable=broad-except
            logger.error(f'Failed to initialize Firestore: {str(e)}')
            raise

    def collection(self, collection_name: str) -> firestore.CollectionReference:
        """Get collection reference"""
        if self.db is None:
            raise RuntimeError('Firestore client not initialized')
        return self.db.collection(collection_name)

    def document(self, collection_name: str, document_id: str) -> firestore.DocumentReference:
        """Get document reference"""
        return self.collection(collection_name).document(document_id)

    def get_document(self, collection_name: str, document_id: str) -> Optional[dict[str, Any]]:
        """Get document data"""
        try:
            doc_ref = self.document(collection_name, document_id)
            doc = doc_ref.get()
            if doc.exists:
                data = doc.to_dict() or {}
                data['id'] = doc.id
                return data
            return None
        except Exception as e:  # pylint: disable=broad-except
            logger.error(f'Failed to get document: {str(e)}')
            return None

    def create_document(
        self,
        collection_name: str,
        data: dict[str, Any],
        document_id: Optional[str] = None,
    ) -> str:
        """Create new document"""
        try:
            if document_id:
                doc_ref = self.document(collection_name, document_id)
                doc_ref.set(data)
                return document_id
            doc_ref = self.collection(collection_name).document()
            doc_ref.set(data)
            return cast(str, doc_ref.id)
        except Exception as e:  # pylint: disable=broad-except
            logger.error(f'Failed to create document: {str(e)}')
            raise

    def update_document(self, collection_name: str, document_id: str, data: dict[str, Any]) -> bool:
        """Update existing document"""
        try:
            doc_ref = self.document(collection_name, document_id)
            doc_ref.update(data)
            return True
        except Exception as e:  # pylint: disable=broad-except
            logger.error(f'Failed to update document: {str(e)}')
            return False

    def delete_document(self, collection_name: str, document_id: str) -> bool:
        """Delete document"""
        try:
            doc_ref = self.document(collection_name, document_id)
            doc_ref.delete()
            return True
        except Exception as e:  # pylint: disable=broad-except
            logger.error(f'Failed to delete document: {str(e)}')
            return False

    def query_collection(
        self,
        collection_name: str,
        filters: Optional[Sequence[Tuple[str, str, Any]]] = None,
        order_by: Optional[Sequence[Tuple[str, Any]]] = None,
        limit: Optional[int] = None,
    ) -> List[dict[str, Any]]:
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
            results: List[dict[str, Any]] = []
            for doc in docs:
                data = doc.to_dict() or {}
                data['id'] = doc.id
                results.append(data)

            return results
        except Exception as e:  # pylint: disable=broad-except
            logger.error(f'Failed to query collection: {str(e)}')
            return []

    def query_collection_no_order(
        self,
        collection_name: str,
        filters: Optional[Sequence[Tuple[str, str, Any]]] = None,
        limit: Optional[int] = None,
    ) -> List[dict[str, Any]]:
        """
        Query collection WITHOUT ORDER BY (avoids index requirement)
        Sorts results in Python instead of Firestore
        """
        try:
            query = self.collection(collection_name)

            # Apply filters only (NO order_by)
            if filters:
                for field, operator, value in filters:
                    logger.info(f'Applying filter: {field} {operator} {value}')  # ⭐ DEBUG
                    query = query.where(field, operator, value)

            # Set limit
            if limit:
                query = query.limit(limit * 2)
                logger.info(f'Query limit set to {limit * 2}')  # ⭐ DEBUG

            # ⭐ EXECUTE QUERY HERE
            docs = list(query.stream())  # Convert to list to materialize
            logger.info(f'Query returned {len(docs)} documents from {collection_name}')  # ⭐ DEBUG

            results: List[dict[str, Any]] = []
            for doc in docs:
                data = doc.to_dict() or {}
                data['id'] = doc.id
                results.append(data)
                logger.debug(f'Document {doc.id}: {data}')  # ⭐ DEBUG

            logger.info(f'Final results: {len(results)} documents')  # ⭐ DEBUG
            return results

        except Exception as e:  # pylint: disable=broad-except
            logger.error(f'🚨 ERROR in query_collection_no_order: {str(e)}', exc_info=True)  # ⭐ DETAILED ERROR
            return []

# Global database instance
db = FirestoreDB()


def init_db(app: "Flask") -> None:
    """Initialize database with Flask app"""
    db.init_app(app)
