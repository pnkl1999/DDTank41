package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import org.aswing.KeyboardManager;
   
   public class BaseExplainFrame extends Sprite implements Disposeable
   {
      
      public static const EXPLAIN_ENTER:String = "explainEnter";
       
      
      private var _bg:Bitmap;
      
      private var _bg1:Scale9CornerImage;
      
      private var _bg2:Scale9CornerImage;
      
      private var _bg3:ScaleBitmapImage;
      
      private var _bmpTitle:Bitmap;
      
      private var _btnEnter:SimpleBitmapButton;
      
      private var _glow:MovieClip;
      
      public function BaseExplainFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.bg012");
         addChild(this._bg);
         this._bmpTitle = ComponentFactory.Instance.creatBitmap("asset.explain.title");
         addChild(this._bmpTitle);
         this._bg1 = ComponentFactory.Instance.creat("trainer.explain.bg1");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creat("trainer.explain.bg2");
         addChild(this._bg2);
         this._bg3 = ComponentFactory.Instance.creat("trainer.explain.bg3");
         addChild(this._bg3);
         this._btnEnter = ComponentFactory.Instance.creat("trainer.explain.btnEnter");
         this._btnEnter.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         addChild(this._btnEnter);
         this._glow = ClassUtils.CreatInstance("asset.explain.enterGlow");
         this._glow.mouseChildren = false;
         this._glow.mouseEnabled = false;
         setTimeout(this.enterGlow,8000);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown,false,1000);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         this._btnEnter.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         dispatchEvent(new Event(BaseExplainFrame.EXPLAIN_ENTER));
         SoundManager.instance.play("008");
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown,false);
            this.__clickHandler(null);
         }
      }
      
      private function enterGlow() : void
      {
         var _loc1_:Point = null;
         if(parent)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGlow");
            this._glow.x = _loc1_.x;
            this._glow.y = _loc1_.y;
            addChild(this._glow);
         }
      }
      
      public function dispose() : void
      {
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown,false);
         this._btnEnter.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._bmpTitle = null;
         this._btnEnter = null;
         this._glow = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
