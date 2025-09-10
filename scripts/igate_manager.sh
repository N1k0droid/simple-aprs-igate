#!/bin/bash

case "$1" in
    start)
        echo "Starting APRS iGate..."
        docker compose up -d
        echo "iGate started. Monitor with: $0 logs"
        ;;
    stop)
        echo "Stopping APRS iGate..."
        docker compose down
        ;;
    restart)
        echo "Restarting APRS iGate..."
        docker compose restart
        ;;
    logs)
        echo "Following iGate logs (Ctrl+C to exit)..."
        docker logs -f aprs-igate
        ;;
    packets)
        echo "Monitoring live packets (Ctrl+C to exit)..."
        docker exec -it aprs-igate nc localhost 8000
        ;;
    status)
        echo "=== APRS iGate Status ==="
        docker ps --filter "name=aprs-igate"
        echo ""
        echo "=== Recent Log Entries ==="
        docker logs --tail 10 aprs-igate
        ;;
    config)
        echo "Current configuration:"
        echo "======================"
        cat .env
        ;;
    edit)
        echo "Editing configuration..."
        nano .env
        echo "Restart iGate to apply changes: $0 restart"
        ;;
    *)
        echo "APRS iGate Manager"
        echo "=================="
        echo "Usage: $0 {start|stop|restart|logs|packets|status|config|edit}"
        echo ""
        echo "Commands:"
        echo "  start   - Start the iGate"
        echo "  stop    - Stop the iGate"
        echo "  restart - Restart the iGate"
        echo "  logs    - Follow container logs"
        echo "  packets - Monitor live APRS packets"
        echo "  status  - Show iGate status"
        echo "  config  - Show current configuration"
        echo "  edit    - Edit configuration (.env file)"
        ;;
esac
