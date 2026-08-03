const lastSaved = new Map(); // tripId -> {ts, coords}

function shouldSave(tripId, nowTs, coords, minSeconds = 5, minMeters = 30, haversine) {
  const entry = lastSaved.get(tripId);
  
  if (!entry) {
    lastSaved.set(tripId, { ts: nowTs, coords });
    return true;
  }

  const elapsed = (nowTs - entry.ts) / 1000;
  const dist = haversine(entry.coords, coords);
  
  if (elapsed >= minSeconds || dist >= minMeters) {
    lastSaved.set(tripId, { ts: nowTs, coords });
    return true;
  }

  return false;
}

module.exports = { 
  shouldSave,
  lastSaved
};