function getYear(original) {
  if (original) {
    const match = original.match(/\d{4}/);
    return match ? match[0] : original;
  }
  return null;
}

module.exports = getYear;
