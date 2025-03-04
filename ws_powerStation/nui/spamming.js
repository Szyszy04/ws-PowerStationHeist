const appSpamming = {
  data() {
    return {
      isVisibleSpamming: false,
      currentWidth: 25,
      addPercentPerClick: null,
      removePercent: null,
    };
  },
  mounted() {
    document.addEventListener('keydown', this.handleClick);
  },
  beforeUnmount() {
    document.removeEventListener('keydown', this.handleClick);
  },
  methods: {
    displaySpamming(bool) {
      this.isVisibleSpamming = bool ?? false;
      this.startGameSpamming(bool);
    },
    updateDataSpamming(removePer, percentPerClick) {
      this.removePercent = removePer;
      this.addPercentPerClick = percentPerClick;
    },
    handleClick(event) {
      if (event.key === 'e') {
        this.currentWidth = Math.min(this.currentWidth + this.addPercentPerClick, 100); 
      }
    },
    async startGameSpamming(bool) {
      if (bool) {
        const intervalId = setInterval(async () => {
          this.currentWidth = Math.max(this.currentWidth - this.removePercent, 0); 

          if (this.currentWidth >= 89) {
            await this.endSpammingGame(true, intervalId);
          } else if (this.currentWidth <= 0) {
            await this.endSpammingGame(false, intervalId);
          }
        }, 300);
      }
    },
    async endSpammingGame(success, intervalId) {
      clearInterval(intervalId);
      this.displaySpamming(false);

      await fetch('https://ws_powerStation/exitSpamming', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ success }),
      });
    },
  },
  template: `
    <div class="conteinerSpamming" v-show="isVisibleSpamming">
      <p>Spam 'E'</p>
      <div class="mainSpamming">
        <div :style="{ width: currentWidth + '%' }" class="userSpamming"></div>
      </div>
    </div>
  `,
};


function createAppInstance(app) {
  return Vue.createApp(app);
}