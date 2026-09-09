import firebase_admin
from firebase_admin import credentials, db
import random
import time
from datetime import datetime

cred = credentials.Certificate("...................")
firebase_admin.initialize_app(cred, {
    'databaseURL': '.......................'
})

realtime_ref     = db.reference('iot/realtime')
history_ref      = db.reference('iot/history')
device_status_ref= db.reference('iot/device_status')

print("Terhubung ke Firebase. Mulai kirim data...")

while True:
    now = datetime.now()
    timestamp = int(time.time())

    data = {
        "temperature": round(random.uniform(25, 35), 1),
        "humidity":    random.randint(60, 90),
        "soil":        random.randint(30, 80),
        "light":       random.randint(100, 700),
        "timestamp":   timestamp
    }

    # 1. Tulis realtime sensor
    realtime_ref.set(data)

    # 2. Tulis history per jam
    date_key = now.strftime("%Y-%m-%d")
    hour_key = now.strftime("%H:00")
    history_ref.child(date_key).child(hour_key).set({
        "temperature": data["temperature"],
        "humidity":    data["humidity"],
        "soil":        data["soil"],
        "light":       data["light"],
        "configName":  "Dummy Config",
        "dayNumber":   random.randint(1, 14),
        "wateringCount": random.randint(0, 3),
        "timestamp":   timestamp
    })

    # 3. Update device_status (simulasi ESP32 online)
    device_status_ref.set({
        "online":    True,
        "last_seen": timestamp,
        "device":    "ESP32-Microgreen-Simulator"
    })

    print(f"[{now.strftime('%H:%M:%S')}] Terkirim -> {data}")
    time.sleep(5)
