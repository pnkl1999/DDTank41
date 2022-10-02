package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import vip.VipController;
   
   public class VipFrame extends Frame
   {
      
      public static const SELF_VIEW:int = 0;
      
      public static const OTHER_VIEW:int = 1;
       
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _giveYourselfOpenBtn:SelectedButton;
      
      private var _giveOthersOpenedBtn:SelectedButton;
      
      private var _vipSp:Disposeable;
      
      private var _head:VipFrameHead;
      
      public function VipFrame()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.vip.vipFrame.title");
         this._giveYourselfOpenBtn = ComponentFactory.Instance.creatComponentByStylename("vip.giveYourselfOpenBtn");
         this._giveOthersOpenedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.giveOthersOpenedBtn");
         this._head = new VipFrameHead();
         addToContent(this._head);
         addToContent(this._giveYourselfOpenBtn);
         addToContent(this._giveOthersOpenedBtn);
         this._selectedButtonGroup = new SelectedButtonGroup(false,1);
         this._selectedButtonGroup.addSelectItem(this._giveYourselfOpenBtn);
         this._selectedButtonGroup.addSelectItem(this._giveOthersOpenedBtn);
         this._selectedButtonGroup.selectIndex = 0;
         this.updateView(SELF_VIEW);
      }
      
      private function updateView(param1:int) : void
      {
         if(this._vipSp)
         {
            this._vipSp.dispose();
         }
         this._vipSp = null;
         switch(param1)
         {
            case SELF_VIEW:
               this._selectedButtonGroup.selectIndex = 0;
               this._vipSp = new GiveYourselfOpenView();
               break;
            case OTHER_VIEW:
               this._selectedButtonGroup.selectIndex = 1;
               this._vipSp = new GiveOthersOpenedView();
         }
         DisplayObject(this._vipSp).y = 130;
         addToContent(DisplayObject(this._vipSp));
         DisplayObject(this._vipSp).parent.setChildIndex(DisplayObject(this._vipSp),0);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._selectedButtonGroup.addEventListener(Event.CHANGE,this.__selectedButtonGroupChange);
      }
      
      private function __selectedButtonGroupChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateView(this._selectedButtonGroup.selectIndex);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._selectedButtonGroup.removeEventListener(Event.CHANGE,this.__selectedButtonGroupChange);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               VipController.instance.hide();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._selectedButtonGroup)
         {
            this._selectedButtonGroup.dispose();
         }
         this._selectedButtonGroup = null;
         if(this._giveYourselfOpenBtn)
         {
            ObjectUtils.disposeObject(this._giveYourselfOpenBtn);
         }
         this._giveYourselfOpenBtn = null;
         if(this._giveOthersOpenedBtn)
         {
            ObjectUtils.disposeObject(this._giveOthersOpenedBtn);
         }
         this._giveOthersOpenedBtn = null;
         if(this._head)
         {
            this._head.dispose();
            this._head = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
