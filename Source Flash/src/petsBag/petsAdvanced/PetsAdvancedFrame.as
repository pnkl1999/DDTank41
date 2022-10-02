package petsBag.petsAdvanced
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.HelpFrame;
   
   public class PetsAdvancedFrame extends Frame
   {
       
      
      private var _hBox:HBox;
      
      private var _BG:Scale9CornerImage;
      
      private var _ringStarBtn:SelectedButton;
      
      private var _evolutionBtn:SelectedButton;
      
      private var _eatPetsBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _currentIndex:int;
      
      private var _view:*;
      
      public function PetsAdvancedFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("PetsAdvancedFrame.bg");
         addToContent(this._BG);
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.hBox");
         addToContent(this._hBox);
         this._ringStarBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStarBtn");
         this._hBox.addChild(this._ringStarBtn);
         this._evolutionBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolutionBtn");
         this._hBox.addChild(this._evolutionBtn);
         this._eatPetsBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPetsBtn");
         if(PathManager.eatPetsEnable)
         {
            this._hBox.addChild(this._eatPetsBtn);
         }
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._ringStarBtn);
         this._btnGroup.addSelectItem(this._evolutionBtn);
         if(PathManager.eatPetsEnable)
         {
            this._btnGroup.addSelectItem(this._eatPetsBtn);
         }
         this._btnGroup.selectIndex = 0;
         this._currentIndex = 0;
         PetsAdvancedManager.Instance.currentViewType = 1;
         PetsAdvancedManager.Instance.isPetsAdvancedViewShow = true;
         this._view = new PetsRisingStarView();
         addToContent(this._view);
      }
      
      public function setBtnEnableFalse() : void
      {
         this._ringStarBtn.enable = false;
         this._evolutionBtn.enable = false;
      }
      
      public function set enableBtn(param1:Boolean) : void
      {
         this._ringStarBtn.mouseEnabled = this._evolutionBtn.mouseEnabled = this._eatPetsBtn.mouseEnabled = param1;
      }
      
      private function addEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      protected function __onPetsHelp(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("petsBag.petsFormHelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("petsBag.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.setButtonPos(165,457);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            if(PetsAdvancedManager.Instance.isAllMovieComplete)
            {
               SoundManager.instance.play("008");
               this.dispose();
            }
         }
      }
      
      protected function __changeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._btnGroup.selectIndex == this._currentIndex)
         {
            return;
         }
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               PetsAdvancedManager.Instance.currentViewType = 1;
               this._view = new PetsRisingStarView();
               break;
            case 1:
               PetsAdvancedManager.Instance.currentViewType = 2;
               this._view = new PetsEvolutionView();
               break;
            case 2:
               PetsAdvancedManager.Instance.currentViewType = 4;
               this._view = new PetsEatView();
         }
         this._currentIndex = this._btnGroup.selectIndex;
         if(this._view)
         {
            addToContent(this._view);
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         PetsAdvancedManager.Instance.isPetsAdvancedViewShow = false;
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
         ObjectUtils.disposeObject(this._ringStarBtn);
         this._ringStarBtn = null;
         ObjectUtils.disposeObject(this._evolutionBtn);
         this._evolutionBtn = null;
         ObjectUtils.disposeObject(this._eatPetsBtn);
         this._eatPetsBtn = null;
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         ObjectUtils.disposeObject(this._btnGroup);
         this._btnGroup = null;
         super.dispose();
      }
   }
}
