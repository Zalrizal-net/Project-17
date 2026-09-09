import firebase_admin
from firebase_admin import credentials, db
import random
import time
from datetime import datetime, timedelta
import math

cred = credentials.Certificate("................")
firebase_admin.initialize_app(cred, {
    'databaseURL': '.......................'
})

history_ref = db.reference('iot/history')

print("Mulai generate data dummy 1 bulan ke belakang...")

today = datetime.now()
total_written = 0

for days_ago in range(30, -1, -1):  # 30 hari lalu sampai hari ini
    date = today - timedelta(days=days_ago)
    date_key = date.strftime("%Y-%m-%d")
    day_data = {}

    for hour in range(0, 24):
        # Simulasi pola realistis microgreen:
        # Suhu: naik siang, turun malam
        # Kelembapan: tinggi pagi/malam, rendah siang
        # Cahaya: 0 malam, naik pagi, puncak siang, turun sore

        hour_key = f"{hour:02d}:00"

        # === Suhu: naik dari pagi, puncak jam 14, turun malam ===
        base_temp = 27 + 5 * math.sin(math.pi * (hour - 6) / 12)
        # Variasi harian (tanaman makin dewasa makin stabil)
        daily_variation = random.uniform(-1.5, 1.5) * (1 - days_ago / 60)
        temp = round(max(22, min(38, base_temp + daily_variation)), 1)

        # === Kelembapan: tinggi pagi, rendah siang ===
        base_humid = 75 - 20 * math.sin(math.pi * (hour - 6) / 12)
        # Setelah penyiraman (jam 7 dan jam 17): kelembapan naik
        if hour in [7, 8, 17, 18]:
            base_humid += 10
        humid_noise = random.randint(-5, 5)
        humidity = max(40, min(95, int(base_humid + humid_noise)))

        # === Cahaya: 0 malam, naik pagi, puncak siang ===
        if 6 <= hour <= 18:
            base_light = 600 * math.sin(math.pi * (hour - 6) / 12)
            # Tambah noise awan
            cloud_factor = random.uniform(0.6, 1.0)
            light = max(50, int(base_light * cloud_factor + random.randint(-20, 20)))
        else:
            # Grow light menyala malam hari (jika diset)
            light = random.choice([0, 0, 0, random.randint(80, 150)])

        # === Soil: fluktuatif, drop lalu naik setelah siram ===
        base_soil = 60
        if hour in [7, 8, 17, 18]:
            base_soil += 15
        soil = max(20, min(100, base_soil + random.randint(-5, 5)))

        day_data[hour_key] = {
            "temperature": temp,
            "humidity": humidity,
            "soil": soil,
            "light": light,
            "configName": "Bayam Merah",
            "dayNumber": 31 - days_ago,
            "wateringCount": 2 if hour >= 17 else (1 if hour >= 7 else 0),
            "timestamp": int(date.replace(hour=hour, minute=0, second=0).timestamp())
        }

    history_ref.child(date_key).set(day_data)
    total_written += len(day_data)
    print(f"  OK {date_key} - {len(day_data)} record ditulis")

print(f"\nSelesai! Total {total_written} record ditulis untuk 31 hari.")
print("   Refresh halaman Grafik dan History di aplikasi.")
