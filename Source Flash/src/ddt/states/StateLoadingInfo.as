package ddt.states
{
   import flash.utils.Dictionary;
   
   public class StateLoadingInfo
   {
       
      
      public var neededUIModule:Vector.<String>;
      
      public var callBack:Function;
      
      public var progress:Dictionary;
      
      public var isComplete:Boolean;
      
      public var isLoading:Boolean;
      
      public var completeedUIModule:Vector.<String>;
      
      public var state:String;
      
      public function StateLoadingInfo()
      {
         this.neededUIModule = new Vector.<String>();
         this.progress = new Dictionary();
         this.completeedUIModule = new Vector.<String>();
         super();
      }
   }
}
