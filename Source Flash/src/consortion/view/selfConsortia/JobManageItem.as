package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaDutyInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   
   public class JobManageItem extends Sprite implements Disposeable
   {
       
      
      private var _name:FilterFrameText;
      
      private var _btn:ScaleFrameImage;
      
      private var _light:Bitmap;
      
      private var _nameBG:Bitmap;
      
      private var _dutyInfo:ConsortiaDutyInfo;
      
      private var _editable:Boolean;
      
      private var _selected:Boolean;
      
      public function JobManageItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._name = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.name");
         this._btn = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.btn");
         this._light = ComponentFactory.Instance.creatBitmap("asset.consortion.jobManage.light");
         this._nameBG = ComponentFactory.Instance.creatBitmap("asset.consortion.jobManageItem.nameBG");
         addChild(this._nameBG);
         addChild(this._name);
         addChild(this._btn);
         addChild(this._light);
         this._light.visible = false;
         this._nameBG.visible = false;
         this._btn.setFrame(1);
         this._btn.buttonMode = true;
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function removeEvent() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      public function set dutyInfo(param1:ConsortiaDutyInfo) : void
      {
         this._dutyInfo = param1;
         this._name.text = this._dutyInfo.DutyName;
         this.selected = false;
      }
      
      private function __btnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.editable = !this.editable;
         if(!this.editable && this.upText)
         {
            ConsortionModelControl.Instance.model.changeDutyListName(this._dutyInfo.DutyID,this._name.text);
            SocketManager.Instance.out.sendConsortiaUpdateDuty(this._dutyInfo.DutyID,this._name.text,this._dutyInfo.Level);
         }
      }
      
      public function set editable(param1:Boolean) : void
      {
         this._editable = param1;
         var _loc2_:int = !!this._editable ? int(int(2)) : int(int(1));
         this._btn.setFrame(_loc2_);
         if(this._editable)
         {
            this._nameBG.visible = true;
            this._name.type = TextFieldType.INPUT;
            this._name.mouseEnabled = true;
            this._name.setFocus();
            this._name.setSelection(this._name.text.length,this._name.text.length);
         }
         else
         {
            this._nameBG.visible = false;
            this._name.type = TextFieldType.DYNAMIC;
            this._name.mouseEnabled = false;
         }
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function get upText() : Boolean
      {
         if(this._name.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaJobItem.null"));
            this.setDefultName();
            return false;
         }
         if(this._name.text == this._dutyInfo.DutyName)
         {
            return false;
         }
         var _loc1_:Vector.<ConsortiaDutyInfo> = ConsortionModelControl.Instance.model.dutyList;
         var _loc2_:int = _loc1_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc1_[_loc3_].DutyName == this._name.text)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaJobItem.diffrent"));
               this.setDefultName();
               return false;
            }
            _loc3_++;
         }
         if(FilterWordManager.isGotForbiddenWords(this._name.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaJobItem.duty"));
            this.setDefultName();
            return false;
         }
         return true;
      }
      
      private function setDefultName() : void
      {
         var _loc1_:Vector.<ConsortiaDutyInfo> = ConsortionModelControl.Instance.model.dutyList;
         var _loc2_:int = _loc1_.length;
         var _loc3_:int = int(this.name);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc3_ == _loc4_)
            {
               this._name.text = _loc1_[_loc4_].DutyName;
            }
            _loc4_++;
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this._light.visible = this._selected;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         if(!this.selected)
         {
            this._light.visible = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._name = null;
         this._btn = null;
         this._light = null;
         this._nameBG = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
