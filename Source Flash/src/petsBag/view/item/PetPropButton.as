package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.view.tips.PropTxtTipInfo;
   import flash.text.TextFormat;
   
   public class PetPropButton extends Component
   {
       
      
      private var _propName:FilterFrameText;
      
      private var _propValue:FilterFrameText;
      
      protected var _tipInfo:PropTxtTipInfo;
      
      private var _currentPropValue:int;
      
      private var _addedPropValue:int;
      
      public function PetPropButton()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._propName = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.propName");
         addChild(this._propName);
         this._propValue = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.propValue");
         addChild(this._propValue);
         this._propName.mouseEnabled = false;
         this._propValue.mouseEnabled = false;
         this._tipInfo = new PropTxtTipInfo();
      }
      
      public function set propName(param1:String) : void
      {
         this._propName.text = param1;
         this.fixPos();
      }
      
      public function set propValue(param1:int) : void
      {
         this._propValue.text = param1.toString();
         this.fixPos();
      }
      
      public function set propColor(param1:int) : void
      {
         var _loc2_:TextFormat = this._propValue.getTextFormat();
         _loc2_.color = param1;
         this._propValue.setTextFormat(_loc2_);
      }
      
      public function set valueFilterString(param1:int) : void
      {
         this._propValue.setFrame(param1);
      }
      
      private function fixPos() : void
      {
         this._propValue.x = 77;
      }
      
      override public function get tipStyle() : String
      {
         return "core.PropTxtTips";
      }
      
      override public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      public function get color() : int
      {
         return this._tipInfo.color;
      }
      
      public function set color(param1:int) : void
      {
         this._tipInfo.color = param1;
      }
      
      public function get property() : String
      {
         return this._tipInfo.property;
      }
      
      public function set property(param1:String) : void
      {
         this._tipInfo.property = "[" + param1 + "] " + this._currentPropValue + "+" + this._addedPropValue + "（" + LanguageMgr.GetTranslation("petsBag.petPropButtonTipSignTxt") + "）";
      }
      
      public function get currentPropValue() : int
      {
         return this._currentPropValue;
      }
      
      public function set currentPropValue(param1:int) : void
      {
         this._currentPropValue = param1;
      }
      
      public function get addedPropValue() : int
      {
         return this._addedPropValue;
      }
      
      public function set addedPropValue(param1:int) : void
      {
         this._addedPropValue = param1;
      }
      
      public function get detail() : String
      {
         return this._tipInfo.detail;
      }
      
      public function set detail(param1:String) : void
      {
         this._tipInfo.detail = param1;
      }
      
      override public function dispose() : void
      {
         this._tipInfo = null;
         ObjectUtils.disposeObject(this._propName);
         this._propName = null;
         ObjectUtils.disposeObject(this._propValue);
         this._propValue = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
