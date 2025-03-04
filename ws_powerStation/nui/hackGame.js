const appHackGame = {
  data() {
    return {
      letters: [],
      correctOrder: [],
      correctLetters: [],
      incorrectLetters: [],
      userInput: '',
      timerRunning: true,
      timeLeft: null,
      animationDuration: null,
      timerInterval: null,
      isGameDisabled: false,
      isVisibleHack: false,
      gameResult: false,
      numberElements: null,
    };
  },
  methods: {
    displayHackGame(bool) {
      this.isVisibleHack = bool;
      this.numberElements = 10;
      this.timeLeft = 30;
      if (bool) this.startTimer();
    },
    updateData(newTime, numberElements){
      this.timeLeft = newTime
      this.numberElements = numberElements
    },
    startTimer() {
      this.animationDuration = this.timeLeft;
      this.$el.classList.remove('disable');
      document.querySelector('.showWin').classList.add('disable');
      document.querySelector('.showLoss').classList.add('disable');

      this.$el.querySelector('.pierwszy').classList.remove('disable');
      this.$el.querySelector('.pierwszTekst').classList.remove('disable');

      const elements = document.querySelectorAll('.active, .circle, .line');
      elements.forEach(element => {
        element.classList.remove('active');
      });

      const elements2 = document.querySelectorAll('.letter');
      elements2.forEach(element => {
        element.classList.remove('correct');
      });

      const svgs = document.querySelectorAll('svg');
      svgs.forEach(svg => {
        svg.classList.add('disable');
      });

      this.initializeGame();
      setTimeout(() => {
        window.addEventListener('keypress', this.handleKeyPress);

        const elements = document.querySelectorAll('.active, .circle');
        elements.forEach(element => {
          element.classList.remove('active');
        });
        
        this.isGameDisabled = true;
        this.$el.querySelector('.pierwszy').classList.add('disable');
        this.$el.querySelector('.pierwszTekst').classList.add('disable');

        const elementsToEnable = this.$el.querySelectorAll('.progressBar, .progress, .input');
        elementsToEnable.forEach(element => {
          element.classList.remove('disable');
        });

        this.timerInterval = setInterval(() => {
          this.timeLeft--;

          if (this.timeLeft === 0) {
            clearInterval(this.timerInterval);
            this.gameResult = false;
            this.$el.querySelector('.showLoss').classList.remove('disable');
            this.endGameFinish()
          }
        }, 1000);
      }, 2000);
    },
    updateProgress() {
      const circles = this.$el.querySelectorAll('.circle');

      for (let i = 0; i < circles.length; i++) {
        if (this.correctLetters.includes(i)) {
          circles[i].classList.add('active');
        }
      }
    },
    initializeGame() {
      this.correctLetters = [];
      this.incorrectLetters = [];
    
      this.letters = this.generateRandomLetters(this.numberElements);
      this.correctOrder = [...this.letters];
      this.userInput = '';
    
      this.$refs.progressContainer.innerHTML = '';

      const elementDiv = document.createElement('div');
      elementDiv.classList.add('element');

      for (let i = 0; i < this.numberElements; i++) {
        const partDiv = document.createElement('div');
        partDiv.classList.add('part');

        const circleDiv = document.createElement('div');
        circleDiv.classList.add('circle');
        const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('class', 'disable');
        svg.setAttribute('width', '12');
        svg.setAttribute('height', '12');
        svg.setAttribute('viewBox', '0 0 12 12');
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', 'M10 3L4.5 8.5L2 6');
        path.setAttribute('stroke', '#8578E9');
        path.setAttribute('stroke-linecap', 'round');
        path.setAttribute('stroke-linejoin', 'round');
        svg.appendChild(path);
        circleDiv.appendChild(svg);
        partDiv.appendChild(circleDiv);

        const letterDiv = document.createElement('div');
        letterDiv.classList.add('letter');
        letterDiv.textContent = this.letters[i];
        partDiv.appendChild(letterDiv);

        elementDiv.appendChild(partDiv);
      }
      this.$refs.progressContainer.appendChild(elementDiv);
    },
    
    generateRandomLetters(count) {
      const characters = 'ABCDEFGHIJKLMNPQRSTUVWXYZ123456789';
      let randomLetters = [];
      for (let i = 0; i < count; i++) {
        const randomIndex = Math.floor(Math.random() * characters.length);
        randomLetters.push(characters[randomIndex]);
      }
      return randomLetters;
    },
    checkInput() {
      if (this.userInput.length === 0) return; 
      const index = this.userInput.length - 1;
    
      if (this.userInput[index] === this.correctOrder[index]) {
        this.correctLetters.push(index);
        const letters = document.querySelectorAll('.letter');
        letters[index].classList.add('correct');
        this.updateProgress();
      } else {
        this.gameResult = false;
        document.querySelector('.showLoss').classList.remove('disable');
        clearInterval(this.timerInterval);
        this.endGameFinish();
      }
    
      if (this.correctLetters.length === this.letters.length) {
        this.gameResult = true;
        document.querySelector('.showWin').classList.remove('disable');
        clearInterval(this.timerInterval);
        this.endGameFinish();
      }
    },
    
    endGameFinish(){
      setTimeout(() => {
        window.removeEventListener('keypress', this.handleKeyPress);

        const elementsToEnable = document.querySelectorAll('.progressBar, .progress, .input, .progressBar2');
        elementsToEnable.forEach(element => {
          element.classList.add('disable');
        });

        document.querySelector('.endGame').classList.remove('disable');
        document.querySelector('.pierwszy').classList.remove('disable');

        const elements = document.querySelectorAll('.active, .circle');
        elements.forEach(element => {
          element.classList.remove('active');
        });

        setTimeout(() => {
          fetch('https://ws_powerStation/exitHack', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ success: this.gameResult })
          });

          window.removeEventListener('keypress', this.handleKeyPress);
          this.numberElements = null;
          this.displayHackGame(false)
        }, 2000);
      }, 10);
    },

    handleKeyPress(event) {
      const key = event.key.toUpperCase();
      if (/^[a-zA-Z0-9]$/.test(key)) { 
        this.userInput += key;
      }
    },
  },
  template: `
    <div id="conteinerHack" class="conteinerHack" v-show="isVisibleHack">
      <div class="progress disable" ref="progressContainer"></div>
      <div class="progressBar disable" :style="{ '--duration': animationDuration }">
        <div class="bar"></div>
      </div>
      <div class="pierwszy">
        <div class="pierwszTekst">Get ready</div>
        <div class="showWin disable">Hack successful</div>
        <div class="showLoss disable">Hack failed</div>
        <div class="progressBar2" style="--duration: 2;">
          <div class="bar"></div>
        </div>
        <div class="endGame disable" style="--duration: 2;">
          <div class="bar"></div>
        </div>
      </div>
    </div>
  `,
  watch: {
    userInput() {
      this.checkInput();
    },
    correctLetters() {
      this.updateProgress();
    },
  },
};


function createAppInstance(app) {
  return Vue.createApp(app);
}