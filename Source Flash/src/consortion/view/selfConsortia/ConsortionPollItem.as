package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortionPollInfo;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortionPollItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _name:FilterFrameText;
      
      private var _count:FilterFrameText;
      
      private var _info:ConsortionPollInfo;
      
      private var _selected:Boolean;
      
      public function ConsortionPollItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.pollItem.bg");
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.pollItem.selected");
         this._name = ComponentFactory.Instance.creatComponentByStylename("consortion.pollItem.name");
         this._count = ComponentFactory.Instance.creatComponentByStylename("consortion.pollItem.count");
         addChild(this._bg);
         addChild(this._selectedBtn);
         addChild(this._name);
         addChild(this._count);
         this._bg.visible = false;
      }
      
      public function set info(param1:ConsortionPollInfo) : void
      {
         this._info = param1;
         this._name.text = this._info.pollName;
         this._count.text = String(this._info.pollCount);
      }
      
      public function get info() : ConsortionPollInfo
      {
         return this._info;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         if(!this.selected)
         {
            this._bg.visible = true;
            this._bg.setFrame(1);
         }
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         if(!this.selected)
         {
            this._bg.visible = false;
            this._bg.setFrame(1);
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this._bg.visible = this._selected;
         if(this._selected)
         {
            this._bg.setFrame(2);
         }
         this._selectedBtn.selected = this._selected;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._selectedBtn = null;
         this._name = null;
         this._count = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
