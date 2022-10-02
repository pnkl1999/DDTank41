package ddt.view.sceneCharacter
{
   public class SceneCharacterActionItem
   {
       
      
      public var type:String;
      
      public var frames:Array;
      
      public var repeat:Boolean;
      
      public function SceneCharacterActionItem(param1:String, param2:Array, param3:Boolean)
      {
         super();
         this.type = param1;
         this.frames = param2;
         this.repeat = param3;
      }
      
      public function dispose() : void
      {
         while(this.frames && this.frames.length > 0)
         {
            this.frames.shift();
         }
         this.frames = null;
      }
   }
}
