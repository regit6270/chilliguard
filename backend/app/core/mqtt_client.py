import logging
import json
from typing import Any, Callable
from app.services.sensor_data_service import store_sensor_reading
from paho.mqtt import client as mqtt
from app.core.config import Config


logger = logging.getLogger(__name__)


class MQTTClient:
    """MQTT client for IoT sensor data"""

    def __init__(self) -> None:
        self.client: Any = None
        self.connected = False
        self.callbacks: dict[str, Callable] = {}

    def connect(self) -> None:
        """Connect to MQTT broker"""
        try:
            self.client = mqtt.Client()

            # Set username and password if provided
            if Config.MQTT_USERNAME and Config.MQTT_PASSWORD:
                self.client.username_pw_set(
                    Config.MQTT_USERNAME,
                    Config.MQTT_PASSWORD
                )

            # Set callbacks
            self.client.on_connect = self._on_connect  # type: ignore[attr-defined]
            self.client.on_disconnect = self._on_disconnect  # type: ignore[attr-defined]
            self.client.on_message = self._on_message  # type: ignore[attr-defined]

            # Connect to broker
            self.client.connect(
                Config.MQTT_BROKER_HOST,
                Config.MQTT_BROKER_PORT,
                60
            )

            # Start loop in background
            self.client.loop_start()

            logger.info(  # type: ignore[attr-defined]
                "Connecting to MQTT broker at %s:%s",
                Config.MQTT_BROKER_HOST,
                Config.MQTT_BROKER_PORT
            )

        except Exception as e:
            logger.error(f'Failed to connect to MQTT broker: {str(e)}')
            raise

    def disconnect(self) -> None:
        """Disconnect from MQTT broker"""
        if self.client:
            self.client.loop_stop()
            self.client.disconnect()
            logger.info('Disconnected from MQTT broker')

    def subscribe(self, topic: str, callback: Callable) -> None:
        """Subscribe to MQTT topic"""
        if self.client:
            self.client.subscribe(topic)
            self.callbacks[topic] = callback
            logger.info(f'Subscribed to topic: {topic}')

    def publish(self, topic: str, payload: Any) -> bool:
        """Publish message to MQTT topic"""
        if self.client and self.connected:
            result = self.client.publish(topic, json.dumps(payload))
            if result.rc == mqtt.MQTT_ERR_SUCCESS:
                logger.debug(f'Published to {topic}: {payload}')
                return True
        return False

    def _on_connect(self, client: mqtt.Client, userdata: Any, flags: Any, rc: int) -> None:
        """Callback for when client connects to broker"""
        if rc == 0:
            self.connected = True
            logger.info('Connected to MQTT broker successfully')

            # Resubscribe to topics
            base_topic = f'{Config.MQTT_TOPIC_PREFIX}/+/sensors/#'
            client.subscribe(base_topic)
            logger.info(f'Subscribed to base topic: {base_topic}')
        else:
            logger.error(
                f'Failed to connect to MQTT broker, return code: {rc}')

    def _on_disconnect(self, rc: int) -> None:
        """Callback for when client disconnects from broker"""
        self.connected = False
        logger.warning(f'Disconnected from MQTT broker, return code: {rc}')

    def _on_message(self, msg: mqtt.MQTTMessage) -> None:
        """Callback for when message is received"""
        try:
            topic = msg.topic
            payload = json.loads(msg.payload.decode())

            logger.debug(f'Received message on {topic}: {payload}')

            # Call registered callback if exists
            for registered_topic, callback in self.callbacks.items():
                if self._topic_matches(registered_topic, topic):
                    callback(topic, payload)
                    break

            # Process sensor data
            self._process_sensor_data(topic, payload)

        except Exception as e:
            logger.error(f'Error processing MQTT message: {str(e)}')

    def _topic_matches(self, pattern: str, topic: str) -> bool:
        """Check if topic matches pattern with wildcards"""
        pattern_parts = pattern.split('/')
        topic_parts = topic.split('/')

        if len(pattern_parts) != len(topic_parts):
            return False

        for pattern_part, topic_part in zip(pattern_parts, topic_parts):
            if pattern_part == '#':
                return True
            if pattern_part != '+' and pattern_part != topic_part:
                return False

        return True

    def _process_sensor_data(self, topic: str, payload: Any) -> None:
        """Process incoming sensor data"""
        try:
            # Extract field_id from topic:
            # chilliguard/fields/{field_id}/sensors/{sensor_type}
            topic_parts = topic.split('/')
            if len(topic_parts) >= 4:
                field_id = topic_parts[2]
                sensor_type = topic_parts[4] if len(
                    topic_parts) > 4 else 'unknown'

                # Import here to avoid circular dependency

                # Store sensor reading in database
                store_sensor_reading(field_id, sensor_type, payload)

        except Exception as e:
            logger.error(f'Error processing sensor data: {str(e)}')


# Global MQTT client instance
mqtt_client = MQTTClient()
