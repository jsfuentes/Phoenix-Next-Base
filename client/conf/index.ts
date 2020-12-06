/*
 Inspired by https://stackoverflow.com/questions/5869216/how-to-store-node-js-deployment-settings-configuration-files
 Mimics the interface of npm package `config`
*/
import _ from "lodash";

import defaults from "./default";
import devConf from "./development";
import prodConf from "./production";

let envConf: any;
if(process.env.NODE_ENV === "development") {
  envConf = devConf;
} else {
  envConf = prodConf;
}

const obj = _.defaultsDeep(envConf, defaults);
// console.log(envConf, process.env.NODE_ENV, obj);

class Config {
  conf: any

  constructor(obj: any) {
    this.conf = obj;
  }

  get(key: string) {
    if (!(key in this.conf)) {
      throw new Error(`${key} not found in configuration, check config folder`);
    }
    return this.conf[key];
  }

  has(key: string) {
    return key in this.conf;
  }
}

const conf = new Config(obj);
export default conf;
