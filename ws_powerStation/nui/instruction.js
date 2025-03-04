const appInstruction = {
  data() {
    return {
      cableData: [],
      isVisibleInstruction: false,  
    };
  },
  mounted() {
    document.addEventListener('keydown', this.handleBackspace);
    window.addEventListener('message', this.handleNuiMessage);
  },
  beforeUnmount() {
    document.removeEventListener('keydown', this.handleBackspace);
    window.removeEventListener('message', this.handleNuiMessage);
  },
  methods: {
    handleBackspace(event) {
      if (event.key === 'Backspace') {
        this.display(false);
        fetch(`https://ws_powerStation/closeUISheet`, { method: 'POST' });
      }
    },
    display(bool) {
      this.isVisibleInstruction = bool ?? false;
    },
    receiveInstruction(instruction) {
      this.cableData = instruction;
      this.display(true);
    },
  },
  template: `
    <div 
      class="conteinerInstruction" 
      v-show="isVisibleInstruction"
      style="
        color: rgba(0, 0, 0, 0.8);
        width: 35rem;
        height: 47rem;
        background-image: url('bg.png');
        background-size: contain;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        font-size: xx-large;
        font-family: cursive;
        transform: rotate(-5deg);
        user-select: none;
      ">
      <div class="contentBox" v-for="(item, index) in cableData" :key="index">
          <p>{{ item?.name ?? 'Unnamed' }} - {{ item?.cables ?? 'No cables' }}</p>
      </div>
    </div>
  `
};


function createAppInstance(app) {
  return Vue.createApp(app);
}
