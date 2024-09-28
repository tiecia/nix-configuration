class IdleInhibitor {
  #state = Utils.exec('matcha -g');

  get inhibited() {
    return this.#state == 'enabled';
  }

  toggle() {
    Utils.exec('matcha -t');
  }
}

const inh = new IdleInhibitor;

export default inh;

