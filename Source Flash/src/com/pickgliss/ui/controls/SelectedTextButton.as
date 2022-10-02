package com.pickgliss.ui.controls
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.geom.OuterRectPos;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class SelectedTextButton extends SelectedButton
   {
      
      public static const P_backgoundInnerRect:String = "backgoundInnerRect";
      
      public static const P_text:String = "text";
      
      public static const P_selectedTextField:String = "selectedtextField";
      
      public static const P_unSelectedTextField:String = "unselectedtextField";
      
      public static const P_selected:String = "selected";
      
      public static const P_unSelectedButtonOuterRectPos:String = "unSelectedButtonOuterRectPos";
       
      
      protected var _selectedTextField:TextField;
      
      protected var _unSelectedTextField:TextField;
      
      protected var _text:String = "";
      
      protected var _textStyle:String;
      
      protected var _selectedBackgoundInnerRect:InnerRectangle;
      
      protected var _unselectedBackgoundInnerRect:InnerRectangle;
      
      protected var _backgoundInnerRectString:String;
      
      protected var _unSelectedButtonOuterRectPosString:String;
      
      protected var _unSelectedButtonOuterRectPos:OuterRectPos;
      
      public function SelectedTextButton()
      {
         this._selectedBackgoundInnerRect = new InnerRectangle(0,0,0,0,-1);
         this._unselectedBackgoundInnerRect = new InnerRectangle(0,0,0,0,-1);
         super();
      }
      
      public function set unSelectedButtonOuterRectPosString(param1:String) : void
      {
         if(this._unSelectedButtonOuterRectPosString == param1)
         {
            return;
         }
         this._unSelectedButtonOuterRectPosString = param1;
         this._unSelectedButtonOuterRectPos = ClassUtils.CreatInstance("com.pickgliss.geom.OuterRectPos",ComponentFactory.parasArgs(this._unSelectedButtonOuterRectPosString));
         onPropertiesChanged("unSelectedButtonOuterRectPos");
      }
      
      public function set backgoundInnerRectString(param1:String) : void
      {
         if(this._backgoundInnerRectString == param1)
         {
            return;
         }
         this._backgoundInnerRectString = param1;
         var _loc2_:Array = ComponentFactory.parasArgs(this._backgoundInnerRectString);
         if(_loc2_.length > 0 && _loc2_[0] != "")
         {
            this._selectedBackgoundInnerRect = ClassUtils.CreatInstance("com.pickgliss.geom.InnerRectangle",String(_loc2_[0]).split("|"));
         }
         if(_loc2_.length > 1 && _loc2_[1] != "")
         {
            this._unselectedBackgoundInnerRect = ClassUtils.CreatInstance("com.pickgliss.geom.InnerRectangle",String(_loc2_[1]).split("|"));
         }
         onPropertiesChanged("backgoundInnerRect");
      }
      
      override public function dispose() : void
      {
         if(this._selectedTextField)
         {
            ObjectUtils.disposeObject(this._selectedTextField);
         }
         this._selectedTextField = null;
         if(this._unSelectedTextField)
         {
            ObjectUtils.disposeObject(this._unSelectedTextField);
         }
         this._unSelectedTextField = null;
         super.dispose();
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         onPropertiesChanged("text");
      }
      
      public function set selectedTextField(param1:TextField) : void
      {
         if(this._selectedTextField == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._selectedTextField);
         this._selectedTextField = param1;
         onPropertiesChanged("selectedtextField");
      }
      
      public function set unSelectedTextField(param1:TextField) : void
      {
         if(this._unSelectedTextField == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._unSelectedTextField);
         this._unSelectedTextField = param1;
         onPropertiesChanged("unselectedtextField");
      }
      
      public function set textStyle(param1:String) : void
      {
         if(this._textStyle == param1)
         {
            return;
         }
         this._textStyle = param1;
         var _loc2_:Array = ComponentFactory.parasArgs(param1);
         if(_loc2_.length > 0 && _loc2_[0] != "")
         {
            this.selectedTextField = ComponentFactory.Instance.creatComponentByStylename(_loc2_[0]);
         }
         if(_loc2_.length > 1 && _loc2_[1] != "")
         {
            this.unSelectedTextField = ComponentFactory.Instance.creatComponentByStylename(_loc2_[1]);
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._selectedTextField)
         {
            addChild(this._selectedTextField);
         }
         if(this._unSelectedTextField)
         {
            addChild(this._unSelectedTextField);
         }
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         if(this._selectedTextField)
         {
            this._selectedTextField.visible = param1;
         }
         if(this._unSelectedTextField)
         {
            this._unSelectedTextField.visible = !param1;
         }
         onPropertiesChanged("selected");
      }
      
      override protected function onProppertiesUpdate() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         super.onProppertiesUpdate();
         if(_selected && this._selectedTextField)
         {
            this._selectedTextField.text = this._text;
         }
         else if(!_selected && this._unSelectedTextField)
         {
            this._unSelectedTextField.text = this._text;
         }
         if(_autoSizeAble)
         {
            if(_selected && this._selectedTextField)
            {
               _loc2_ = this._selectedBackgoundInnerRect.getInnerRect(this._selectedTextField.textWidth,this._selectedTextField.textHeight);
               _width = _selectedButton.width = _loc2_.width;
               _height = _selectedButton.height = _loc2_.height;
               this._selectedTextField.x = this._selectedBackgoundInnerRect.para1;
               this._selectedTextField.y = this._selectedBackgoundInnerRect.para3;
            }
            else if(!_selected && this._unSelectedTextField)
            {
               this.upUnselectedButtonPos();
               _loc1_ = this._unselectedBackgoundInnerRect.getInnerRect(this._unSelectedTextField.textWidth,this._unSelectedTextField.textHeight);
               _width = _unSelectedButton.width = _loc1_.width;
               _height = _unSelectedButton.height = _loc1_.height;
               this._unSelectedTextField.x = this._unselectedBackgoundInnerRect.para1 + _unSelectedButton.x;
               this._unSelectedTextField.y = this._unselectedBackgoundInnerRect.para3 + _unSelectedButton.y;
            }
            else if(_selected)
            {
               _width = _selectedButton.width;
               _height = _selectedButton.height;
            }
            else
            {
               this.upUnselectedButtonPos();
               _width = _unSelectedButton.width;
               _height = _unSelectedButton.height;
            }
         }
         else
         {
            this.upUnselectedButtonPos();
            _selectedButton.width = _unSelectedButton.width = _width;
            _selectedButton.height = _unSelectedButton.height = _height;
            if(this._selectedTextField)
            {
               this._selectedTextField.x = (_width - this._selectedTextField.textWidth) / 2;
               this._selectedTextField.y = (_height - this._selectedTextField.textHeight) / 2;
            }
            if(this._unSelectedTextField)
            {
               this._unSelectedTextField.x = (_width - this._unSelectedTextField.textWidth) / 2;
               this._unSelectedTextField.y = (_height - this._unSelectedTextField.textHeight) / 2;
            }
         }
      }
      
      private function upUnselectedButtonPos() : void
      {
         if(_unSelectedButton == null || _selectedButton == null)
         {
            return;
         }
         if(this._unSelectedButtonOuterRectPos == null)
         {
            return;
         }
         var _loc1_:Point = this._unSelectedButtonOuterRectPos.getPos(_unSelectedButton.width,_unSelectedButton.height,_selectedButton.width,_selectedButton.height);
         _unSelectedButton.x = _loc1_.x;
         _unSelectedButton.y = _loc1_.y;
      }
   }
}
