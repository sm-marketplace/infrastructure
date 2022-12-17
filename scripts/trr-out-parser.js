module.exports.TrrOutParser = class TrrOutParser {

  constructor(outJson) {
    this.outJson = outJson;
  }

  get stages() {
    return this.outJson['stages'].value;
  }

  value(key, stage) {
    const idx = this.outJson['stages'].value.indexOf(stage)
    const res = this.outJson[key]

    return res.value[idx]
  }
}