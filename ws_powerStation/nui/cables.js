const appCabels = {
  data() {
    return {
      isVisibleCabels: true,
      isVisibleCabelSymbol: true,
      isVisibleCabelGame: false,
      isVisibleCabelEnd: false,
      symbol: '',
      textEnd: '',
      disabledParts: {},
      numbers: [],         
      clickedOrder: [], 
    };
  },
  methods: {
    displayCabels(bool) {
      this.isVisibleCabels = bool;
    },
    
    resetGame() {
      this.isVisibleCabels = false;
      this.isVisibleCabelGame = false;
      this.isVisibleCabelEnd = false;
      this.symbol = '';
      this.textEnd = '';
      this.disabledParts = {};
      this.numbers = [];
      this.clickedOrder = [];
    },

    startGameCabels(cableData) {
      this.symbol = cableData.name;
      this.numbers = cableData.cables.match(/\d+/g).map(Number);

      setTimeout(() => {
          this.isVisibleCabelSymbol = false;
          this.isVisibleCabelGame = true;
      }, 3000);
    },

    isCorrectOrder() {
      for (let i = 0; i < this.clickedOrder.length; i++) {
        if (this.clickedOrder[i] !== this.numbers[i]) {
          return false;
        }
      }
      return true;
    },

    disablePart(cableNumber, part) {
      this.clickedOrder.push(cableNumber);

      if (!this.isCorrectOrder()) {
        this.endGame(false); // Loss
      } else if (this.clickedOrder.length === this.numbers.length) {
        this.endGame(true);  // Win
      }

      if (!this.disabledParts[cableNumber]) {
        this.disabledParts[cableNumber] = { hideBg: false };
      }
      this.disabledParts[cableNumber][part] = true;
      this.disabledParts[cableNumber].hideBg = true;
    },

    isDisabled(cableNumber, part) {
      return this.disabledParts[cableNumber] && this.disabledParts[cableNumber][part];
    },

    isBgHidden(cableNumber) {
      return this.disabledParts[cableNumber] && this.disabledParts[cableNumber].hideBg;
    },

    endGame(bool) {
      this.clickedOrder = [];
      this.isVisibleCabelSymbol = false;
      this.isVisibleCabelGame = false;
      this.isVisibleCabelEnd = true;

      this.textEnd = bool ? 'Hack successful!' : 'Hack failed!';

      setTimeout(() => {
        this.isVisibleCabelEnd = false;
        fetch('https://ws_powerStation/exitCabels', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ success: bool })
        });
        this.resetGame()
      }, 2000);
    }
  },
  template: `
    <div class="conteinerCabels" v-show="isVisibleCabels">
      <p class="cabelSymbol" v-show="isVisibleCabelSymbol">{{ symbol }}</p>
      <div class="cabelGame" v-show="isVisibleCabelGame">
        <div class="cabelMain" v-for="i in 4" :key="i">
          <div 
            class="cabelBg" 
            :class="{ hide: isBgHidden(i) }" >
            <div 
              :class="['cabelTop', { disable: isDisabled(i, 'top') }]" 
              @click="disablePart(i, 'top')">
            </div>
            <div 
              :class="['cabelBottom', { disable: isDisabled(i, 'bottom') }]" 
              @click="disablePart(i, 'bottom')">
            </div>
          </div>
        </div>
      </div>
      <p class="cabelEnd" v-show="isVisibleCabelEnd">{{ textEnd }}</p>
    </div>`
};

function createAppInstance(app) {
  return Vue.createApp(app);
}
