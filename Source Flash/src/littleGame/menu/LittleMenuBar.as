package littleGame.menu
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import littleGame.LittleGameManager;
   
   public class LittleMenuBar extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _returnButton:BaseButton;
      
      private var _switchButton:SwitchButton;
      
      private var _mode:int = 1;
      
      public function LittleMenuBar()
      {
         super();
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("asset.littleGame.menuBG");
         addChild(this._back);
         this._returnButton = ComponentFactory.Instance.creatComponentByStylename("littleGame.ReturnButton");
         addChild(this._returnButton);
         this._switchButton = new SwitchButton();
         addChild(this._switchButton);
         this._switchButton.mode = this._mode;
      }
      
      private function addEvent() : void
      {
         this._switchButton.addEventListener(MouseEvent.CLICK,this.__switchMode);
         this._returnButton.addEventListener(MouseEvent.CLICK,this.__return);
      }
      
      private function __return(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LittleGameManager.Instance.leave();
      }
      
      private function __switchMode(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._mode == 1)
         {
            this._mode = 2;
            this.hide();
         }
         else
         {
            this._mode = 1;
            this.show();
         }
         this._switchButton.mode = this._mode;
      }
      
      private function hide() : void
      {
         var pos:Point = ComponentFactory.Instance.creatCustomObject("littleGame.menu.pos2");
         TweenLite.to(this,0.3,{"x":pos.x});
      }
      
      private function show() : void
      {
         var pos:Point = ComponentFactory.Instance.creatCustomObject("littleGame.menu.pos1");
         TweenLite.to(this,0.3,{"x":pos.x});
      }
      
      private function removeEvent() : void
      {
         this._switchButton.removeEventListener(MouseEvent.CLICK,this.__switchMode);
         this._returnButton.removeEventListener(MouseEvent.CLICK,this.__return);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._switchButton);
         this._switchButton = null;
         ObjectUtils.disposeObject(this._returnButton);
         this._returnButton = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
