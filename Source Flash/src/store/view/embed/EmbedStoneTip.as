package store.view.embed
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class EmbedStoneTip extends GoodTip
   {
      
      public static const P_backgoundInnerRect:String = "backOutterRect";
      
      public static const P_tipTextField:String = "tipTextField";
       
      
      protected var _backInnerRect:InnerRectangle;
      
      protected var _backgoundInnerRectString:String;
      
      protected var _tipTextField:TextField;
      
      protected var _tipTextStyle:String;
      
      private var _currentData:Object;
      
      public function EmbedStoneTip()
      {
         super();
      }
      
      public function set backgoundInnerRectString(param1:String) : void
      {
         if(this._backgoundInnerRectString == param1)
         {
            return;
         }
         this._backgoundInnerRectString = param1;
         this._backInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._backgoundInnerRectString));
         onPropertiesChanged(P_backgoundInnerRect);
      }
      
      override public function dispose() : void
      {
         if(this._tipTextField)
         {
            ObjectUtils.disposeObject(this._tipTextField);
         }
         this._tipTextField = null;
         super.dispose();
      }
      
      public function set tipTextField(param1:TextField) : void
      {
         if(this._tipTextField == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._tipTextField);
         this._tipTextField = param1;
         onPropertiesChanged(P_tipTextField);
      }
      
      public function set tipTextStyle(param1:String) : void
      {
         if(this._tipTextStyle == param1)
         {
            return;
         }
         this._tipTextStyle = param1;
         this.tipTextField = ComponentFactory.Instance.creat(this._tipTextStyle);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._tipTextField)
         {
            addChild(this._tipTextField);
         }
         if(_tipData is DisplayObject)
         {
            addChild(_tipData as DisplayObject);
         }
      }
      
      override public function get tipData() : Object
      {
         return this._currentData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc2_:Rectangle = null;
         _loc2_ = null;
         var _loc3_:GoodTipInfo = null;
         if(param1 as String)
         {
            if(param1 is String)
            {
               this._tipTextField.wordWrap = false;
               this._tipTextField.text = String(param1);
               _loc2_ = this._backInnerRect.getInnerRect(this._tipTextField.width,this._tipTextField.height);
               _width = _tipbackgound.width = _loc2_.width;
               _height = _tipbackgound.height = _loc2_.height;
            }
            else if(param1 is Array)
            {
               this._tipTextField.wordWrap = true;
               this._tipTextField.width = int(param1[1]);
               this._tipTextField.text = String(param1[0]);
               _loc2_ = this._backInnerRect.getInnerRect(this._tipTextField.width,this._tipTextField.height);
               _width = _tipbackgound.width = _loc2_.width;
               _height = _tipbackgound.height = _loc2_.height;
            }
            visible = true;
            this._tipTextField.x = this._backInnerRect.para1;
            this._tipTextField.y = this._backInnerRect.para3;
            this._currentData = param1;
         }
         else if(param1 as GoodTipInfo)
         {
            _loc3_ = param1 as GoodTipInfo;
            this._currentData = _loc3_;
            showTip(_loc3_.itemInfo,_loc3_.typeIsSecond);
            visible = true;
         }
         else
         {
            visible = false;
            this._currentData = null;
         }
      }
   }
}
