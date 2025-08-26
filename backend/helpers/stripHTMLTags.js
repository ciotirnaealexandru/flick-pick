function stripHTMLTags(original) {
  return original.replace(/(<([^>]+)>)/gi, "");
}

module.exports = stripHTMLTags;
