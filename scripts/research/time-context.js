/** Capture once at the player action, never at queue retry or server receipt. */
export function createTimeContext(date = new Date()) {
  let timezone = "unknown";
  try {
    const resolved = Intl.DateTimeFormat().resolvedOptions().timeZone;
    if (typeof resolved === "string" && resolved.trim()) {
      timezone = resolved;
    }
  } catch {
    // Keep recording even if Intl or the browser timezone is unavailable.
  }
  const pad = (value) => String(value).padStart(2, "0");
  return {
    timestamp: date.toISOString(),
    localTimestamp: `${String(date.getFullYear()).padStart(4, "0")}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`,
    timezone,
  };
}
