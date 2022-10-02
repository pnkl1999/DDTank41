package ddt.command
{
   public class PlayerAction
   {
       
      
      public var type:String;
      
      public var stopAtEnd:Boolean;
      
      public var frames:Array;
      
      public var repeat:Boolean;
      
      public var replaceSame:Boolean;
      
      public function PlayerAction(param1:String, param2:Array, param3:Boolean, param4:Boolean, param5:Boolean)
      {
         super();
         this.type = param1;
         this.frames = param2;
         this.replaceSame = param3;
         this.repeat = param4;
         this.stopAtEnd = param5;
      }
      
      public function canReplace(param1:PlayerAction) : Boolean
      {
         if(this.type == "handclip" && param1.type == "walk")
         {
            return false;
         }
         return param1.type != this.type || this.replaceSame;
      }
      
      public function toString() : String
      {
         return this.type;
      }
   }
}
