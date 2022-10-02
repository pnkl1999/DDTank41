package wonderfulActivity.views
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Sprite;
   
   public interface IRightView extends Disposeable
   {
       
      
      function init() : void;
      
      function content() : Sprite;
      
      function setState(param1:int, param2:int) : void;
   }
}
