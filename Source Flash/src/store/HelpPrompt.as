package store
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   
   public class HelpPrompt extends Component
   {
       
      
      private var _bg9Scale:Scale9CornerImage;
      
      public var bg9ScalseStyle:String;
      
      public var contentStyle:String;
      
      private var contentArr:Array;
      
      public function HelpPrompt()
      {
         super();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         var _loc3_:DisplayObject = null;
         super.onProppertiesUpdate();
         this._bg9Scale = ComponentFactory.Instance.creat(this.bg9ScalseStyle);
         addChild(this._bg9Scale);
         var _loc1_:Array = this.contentStyle.split(/,/g);
         this.contentArr = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = ComponentFactory.Instance.creat(_loc1_[_loc2_]);
            addChild(_loc3_);
            this.contentArr.push(_loc3_);
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._bg9Scale)
         {
            ObjectUtils.disposeObject(this._bg9Scale);
         }
         this._bg9Scale = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.contentArr.length)
         {
            ObjectUtils.disposeObject(this.contentArr[_loc1_]);
            this.contentArr[_loc1_] = null;
            _loc1_++;
         }
         this.contentArr = null;
      }
   }
}
