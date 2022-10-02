package labyrinth.data
{
   public class CleanOutInfo
   {
       
      
      public var FamRaidLevel:int;
      
      public var exp:int;
      
      public var TemplateIDs:Array;
      
      public var HardCurrency:int;
      
      public function CleanOutInfo()
      {
         this.TemplateIDs = [];
         super();
      }
   }
}
