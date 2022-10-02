package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   public class DoubleSelectedItem extends Sprite implements IEventDispatcher
   {
      
      private static const NOBIND:int = 1;
      
      private static const BIND:int = 0;
       
      
      private var _isBind:Boolean;
      
      private var _selectedBandBtn:SelectedCheckButton;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _group1:SelectedButtonGroup;
      
      private var _bandMoneyTxt:FilterFrameText;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _back:MovieClip;
      
      public function DoubleSelectedItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("asset.core.stranDown");
         this._back.x = 0;
         this._back.y = 0;
         addChild(this._back);
         this._isBind = true;
         this._selectedBandBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBandBtn.x = 37;
         this._selectedBandBtn.y = -16;
         this._selectedBandBtn.selected = true;
         this._selectedBandBtn.mouseEnabled = false;
         addChild(this._selectedBandBtn);
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBtn.x = -80;
         this._selectedBtn.y = -16;
         addChild(this._selectedBtn);
         this._group1 = new SelectedButtonGroup();
         this._group1.addSelectItem(this._selectedBandBtn);
         this._group1.addSelectItem(this._selectedBtn);
         this._bandMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._bandMoneyTxt.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText3");
         this._bandMoneyTxt.x = 25;
         this._bandMoneyTxt.y = -8;
         addChild(this._bandMoneyTxt);
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._moneyTxt.text = LanguageMgr.GetTranslation("createConsortionFrame.ticketText.Text2");
         this._moneyTxt.x = -108;
         this._moneyTxt.y = -8;
         addChild(this._moneyTxt);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this._group1.addEventListener(Event.CHANGE,this.changeHander);
      }
      
      private function changeHander(param1:Event) : void
      {
         var _loc2_:int = this._group1.selectIndex;
         switch(_loc2_)
         {
            case BIND:
               this._isBind = true;
               this._selectedBtn.mouseEnabled = true;
               this._selectedBandBtn.mouseEnabled = false;
               this._selectedBtn.selected = false;
               this._selectedBandBtn.selected = true;
               break;
            case NOBIND:
               this._isBind = false;
               this._selectedBtn.mouseEnabled = false;
               this._selectedBandBtn.mouseEnabled = true;
               this._selectedBandBtn.selected = false;
               this._selectedBtn.selected = true;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get isBind() : Boolean
      {
         return this._isBind;
      }
      
      public function dispose() : void
      {
         this._group1.dispose();
         this._group1.removeEventListener(Event.CHANGE,this.changeHander);
         this._isBind = false;
         while(numChildren)
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}
