import {queryParams} from "./path.ts";
import {RouteParams} from "./RouteParams";

class Route {

  private state: any;

  constructor(
    public pathname: RegExp,
    public content: string,
    public mount: (Object) => (any),
    public destroy: (any) => void,
    public params?: RouteParams) {}

  public parseParams() {
    const pageParams = queryParams();
    if (!this.params) {
      return {};
    }

    const required = this.params.required.map((key) => {
        if (!(key in pageParams)) {
          throw new Error(`${key} not found in page params.  params: ${JSON.stringify(pageParams)}`);
        }
        const result = {};
        result[key] = pageParams[key];
        return result;
      })
      .reduce((acc, item) => Object.assign(acc, item), {});
    const optional = this.params.optional.map((key) => {
          if (!(key in pageParams)) {
            return {};
          }
          const result = {};
          result[key] = pageParams[key];
          return result;
        })
        .reduce((acc, item) => Object.assign(acc, item), {});

    return Object.assign({}, required, optional);
  }

  public setState(state) {this.state = state; }
  public getState() { return this.state; }
}

export {Route};
