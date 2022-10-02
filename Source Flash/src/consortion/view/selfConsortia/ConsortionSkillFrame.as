package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionSkillFrame extends Frame
   {
      
      public static const CONSORTION_SKILL:int = 0;
      
      public static const PERSONAL_SKILL_CON:int = 1;
      
      public static const PERSONAL_SKILL_METAL:int = 2;
       
      
      private var _bg:Scale9CornerImage;
      
      private var _richbg:ScaleFrameImage;
      
      private var _riches:FilterFrameText;
      
      private var _manager:BaseButton;
      
      private var _consortionSkill:SelectedButton;
      
      private var _personalSkill:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _contribute:SelectedButton;
      
      private var _metal:SelectedButton;
      
      private var _cmGroup:SelectedButtonGroup;
      
      private var _scrollbg:Scale9CornerImage;
      
      private var _vbox:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _items:Vector.<ConsortionSkillItem>;
      
      private var _oldType:int = 0;
      
      public function ConsortionSkillFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.skillFrame.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.bg");
         this._scrollbg = ComponentFactory.Instance.creatComponentByStylename("consortion.SkillItemBtn.scallBG");
         this._richbg = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.richesbg");
         this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.riches");
         this._manager = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.manager");
         PositionUtils.setPos(this._manager,"consortion.killFrame.managePos");
         this._consortionSkill = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.consortionSkill");
         this._personalSkill = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.personalSkill");
         this._contribute = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.contribute");
         this._metal = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.metal");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.vbox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.panel");
         addToContent(this._bg);
         addToContent(this._scrollbg);
         addToContent(this._richbg);
         addToContent(this._riches);
         addToContent(this._manager);
         addToContent(this._consortionSkill);
         addToContent(this._personalSkill);
         addToContent(this._contribute);
         addToContent(this._metal);
         addToContent(this._panel);
         this._panel.setView(this._vbox);
         this._cmGroup = new SelectedButtonGroup();
         this._cmGroup.addSelectItem(this._contribute);
         this._cmGroup.addSelectItem(this._metal);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._consortionSkill);
         this._btnGroup.addSelectItem(this._personalSkill);
         this._btnGroup.selectIndex = 0;
         this.showContent(this._btnGroup.selectIndex + 1);
      }
      
      private function cmGroupVisible(param1:Boolean) : void
      {
         this._metal.visible = param1;
         this._contribute.visible = param1;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._manager.addEventListener(MouseEvent.CLICK,this.__manageHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._cmGroup.addEventListener(Event.CHANGE,this.__cmChangeHandler);
         ConsortionModelControl.Instance.addEventListener(ConsortionEvent.SKILL_STATE_CHANGE,this.__stateChange);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__richChangeHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfRichChangeHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._manager.removeEventListener(MouseEvent.CLICK,this.__manageHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._cmGroup.removeEventListener(Event.CHANGE,this.__cmChangeHandler);
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.SKILL_STATE_CHANGE,this.__stateChange);
         PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__richChangeHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfRichChangeHandler);
      }
      
      protected function __cmChangeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.showContent(this._cmGroup.selectIndex + 2);
      }
      
      private function __richChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[ConsortiaInfo.RICHES] && this._btnGroup.selectIndex == 0)
         {
            this._riches.text = String(PlayerManager.Instance.Self.consortiaInfo.Riches);
         }
      }
      
      private function __selfRichChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if((param1.changedProperties["RichesRob"] || param1.changedProperties["RichesOffer"]) && this._btnGroup.selectIndex == 1)
         {
            this._riches.text = String(PlayerManager.Instance.Self.Riches);
         }
      }
      
      private function __stateChange(param1:ConsortionEvent) : void
      {
         this.showContent(this._oldType);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __manageHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ConsortionModelControl.Instance.alertManagerFrame();
      }
      
      private function __changeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.showContent(this._btnGroup.selectIndex + 1);
      }
      
      private function showContent(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:ConsortionSkillItem = null;
         var _loc6_:int = 0;
         this._oldType = param1;
         this.clearItem();
         if(param1 == 1)
         {
            this._scrollbg.height = 446;
            this._scrollbg.y = 87;
            this._panel.height = 422;
            this._panel.y = 100;
            this.cmGroupVisible(false);
         }
         else
         {
            this._scrollbg.height = 420;
            this._scrollbg.y = 109;
            this._panel.height = 392;
            this._panel.y = 125;
            this.cmGroupVisible(true);
            if(param1 == 2)
            {
               this._cmGroup.selectIndex = 0;
            }
            else
            {
               this._cmGroup.selectIndex = 1;
            }
         }
         this._richbg.setFrame(param1);
         this._riches.text = param1 == 1 ? String(PlayerManager.Instance.Self.consortiaInfo.Riches) : (param1 == 2 ? String(PlayerManager.Instance.Self.Riches) : String(PlayerManager.Instance.Self.medal));
         if(this._items && this._items.length == 0)
         {
            _loc2_ = 0;
            while(_loc2_ < ConsortionModel.SKILL_MAX_LEVEL)
            {
               _loc3_ = _loc2_ + 1 > PlayerManager.Instance.Self.consortiaInfo.BufferLevel ? Boolean(Boolean(false)) : Boolean(Boolean(true));
               _loc4_ = param1 == 3 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
               _loc5_ = new ConsortionSkillItem(_loc2_ + 1,_loc3_,_loc4_);
               _loc6_ = param1 == 3 ? int(int(2)) : int(int(param1));
               _loc5_.data = ConsortionModelControl.Instance.model.getskillInfoWithTypeAndLevel(_loc6_,_loc2_ + 1);
               this._vbox.addChild(_loc5_);
               this._items.push(_loc5_);
               _loc2_++;
            }
            this._panel.invalidateViewport();
         }
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         if(this._items)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               this._items[_loc1_].dispose();
               this._items[_loc1_] = null;
               _loc1_++;
            }
         }
         this._items = new Vector.<ConsortionSkillItem>();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearItem();
         this._items = null;
         super.dispose();
         this._bg = null;
         this._metal = null;
         this._cmGroup = null;
         this._richbg = null;
         this._riches = null;
         this._manager = null;
         this._consortionSkill = null;
         this._personalSkill = null;
         this._btnGroup = null;
         this._vbox = null;
         this._panel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
