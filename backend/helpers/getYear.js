function getYear(original) {
  const match = original.match(/\d{4}/);
  return match ? match[0] : original;
}

module.exports = getYear;
