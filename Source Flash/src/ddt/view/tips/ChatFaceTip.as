package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class ChatFaceTip extends Sprite implements Disposeable, ITip
   {
       
      
      private var _minW:int;
      
      private var _minH:int;
      
      private var tip_txt:FilterFrameText;
      
      private var _tempData:Object;
      
      public function ChatFaceTip()
      {
         super();
         this.tip_txt = ComponentFactory.Instance.creat("core.ChatFaceTxt");
         this.tip_txt.border = true;
         this.tip_txt.background = true;
         this.tip_txt.backgroundColor = 16777215;
         this.tip_txt.borderColor = 3355443;
         this.tip_txt.mouseEnabled = false;
         this._minW = this.tip_txt.width;
         this.mouseChildren = false;
         this.init();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this.tip_txt);
         this.tip_txt = null;
         ObjectUtils.disposeObject(this);
      }
      
      public function get tipData() : Object
      {
         return this._tempData;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(param1 is String && param1 != "")
         {
            this.tip_txt.width = this.updateW(String(param1));
            this.tip_txt.text = String(param1);
            this.visible = true;
         }
         else
         {
            this.visible = false;
         }
         this._tempData = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function init() : void
      {
         addChild(this.tip_txt);
      }
      
      private function updateW(param1:String) : int
      {
         var _loc2_:TextField = new TextField();
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.text = param1;
         if(_loc2_.width < this._minW)
         {
            return this._minW;
         }
         return int(_loc2_.width + 8);
      }
   }
}
