package game.view.effects
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ShowEffect extends Sprite implements Disposeable
   {
      
      public static var GUARD:String = "guard";
       
      
      private var _type:String;
      
      private var _pic:DisplayObject;
      
      private var tmp:int = 0;
      
      private var add:Boolean = true;
      
      public function ShowEffect(param1:String)
      {
         super();
         this._type = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.initPicture();
         addChild(this._pic);
         addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         if(this._pic.alpha > 0.95)
         {
            ++this.tmp;
            if(this.tmp == 20)
            {
               this.add = false;
               this._pic.alpha = 0.9;
            }
         }
         if(this._pic.alpha < 1)
         {
            if(this.add)
            {
               this._pic.y -= 8;
               this._pic.alpha += 0.22;
            }
            else
            {
               this._pic.y -= 6;
               this._pic.alpha -= 0.1;
            }
         }
         if(this._pic.alpha < 0.05)
         {
            this.dispose();
         }
      }
      
      private function initPicture() : void
      {
         switch(this._type)
         {
            case GUARD:
               this._pic = ComponentFactory.Instance.creatBitmap("asset.game.guardAsset") as Bitmap;
               break;
            default:
               this._pic = new MovieClip();
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         if(parent)
         {
            parent.removeChild(this);
         }
         this._pic = null;
      }
   }
}
