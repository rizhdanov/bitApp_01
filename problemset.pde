class problemset
{
  XML xml;
  int level;
  XML[] problems;
  XML[] solutions;
  NoRepeatRandom rnd;
  
  problemset(String filename)
  {
    problemset = problemset(filename,1);
  }
  
  problemset(String filename, int lvl)
  {
    xml = loadXML(filename);
    level = lvl;
    this.loadProblems();
    if (problems != null){
      
    
      this.loadSolutions();
    }    
  }
  
  void loadProblems(){
    int nlevels = xml.getChildCount();
    //println(nlevels);
    
    for (int i = 0; i < nlevels; i++)
    {      
      if (xml.getChild(i).getInt("l") == level && xml.getChild(i).getName() == "level"){
        problems = xml.getChild(i).getChildren("problem");
        println(problems.length);
        rnd = new NoRepeatRandom(0,problems.length-1);
        return;
      }
    }
    //println(xml.getChild(0));
    //load last available level again
    problems = xml.getChild(nlevels-1).getChildren("problem");
    
  }
  
  void loadSolutions(){
  int nlevels = xml.getChildCount();
    for (int i = 0; i < nlevels; i++)
    {
      if (xml.getChild(i).getInt("l") == level && xml.getChild(i).getName() == "level"){
        solutions = xml.getChild(i).getChildren("solution");
        return;
      }
    }
    solutions = null;
  }
  
  XML getNextProblem(){
        //int nproblems = problems.length;
        int t = rnd.GetRandom();
        return problems[t];
  }
  
  XML getSolution(int id){
    for(int j=0;j<solutions.length;j++){
      if(solutions[j].getInt("id") == id){
        
        return solutions[j];
      }
    }
  }
  
}

