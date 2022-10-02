package ddt.view.character
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.PlayerInfo;
   import flash.display.IDisplayObject;
   import flash.geom.Point;
   
   public interface ICharacter extends IColorEditable, IDisplayObject, Disposeable
   {
       
      
      function get info() : PlayerInfo;
      
      function get currentFrame() : int;
      
      function doAction(param1:*) : void;
      
      function actionPlaying() : Boolean;
      
      function show(param1:Boolean = true, param2:int = 1, param3:Boolean = true) : void;
      
      function setFactory(param1:ICharacterLoaderFactory) : void;
      
      function set smoothing(param1:Boolean) : void;
      
      function set showGun(param1:Boolean) : void;
      
      function setShowLight(param1:Boolean, param2:Point = null) : void;
      
      function drawFrame(param1:int, param2:int = 0, param3:Boolean = true) : void;
      
      function get currentAction() : *;
      
      function get characterWidth() : Number;
      
      function get characterHeight() : Number;
      
      function get completed() : Boolean;
      
      function setDefaultAction(param1:*) : void;
   }
}
