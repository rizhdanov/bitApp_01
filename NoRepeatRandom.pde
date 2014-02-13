class NoRepeatRandom {

  int[] number = null;
  int N = -1;
  int size = 0;
  
  NoRepeatRandom(int minVal, int maxVal)
  {
    N = (maxVal - minVal) + 1;
    number = new int[N];
    int n = minVal;
    for(int i = 0; i < N; i++)
      number[i] = n++;
    size = N;
  }

  void Reset() { size = N; }

   // Returns -1 if none left
  int GetRandom()
  {
    if(size <= 0) this.Reset();
    int index = (int)(size * Math.random());
    int randNum = number[index];

    // Swap current value with current last, so we don't actually
    // have to remove anything, and our list still contains everything
    // if we want to reset
    number[index] = number[size-1];
    number[--size] = randNum;

    return randNum;
  }
}

