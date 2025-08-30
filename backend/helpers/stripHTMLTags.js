function stripHTMLTags(original) {
  if (original != null) return original.replace(/(<([^>]+)>)/gi, "");
  return "";
}

module.exports = stripHTMLTags;
