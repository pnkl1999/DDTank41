package exitPrompt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class MissionSprite extends Sprite implements Disposeable
   {
       
      
      public var oldHeight:int;
      
      private const BG_X:int = 4;
      
      public const BG_Y:int = -37;
      
      private const BG_WIDTH:int = 315;
      
      private var _arr:Array;
      
      public function MissionSprite(param1:Array)
      {
         super();
         this._arr = param1;
         this._init(this._arr);
      }
      
      private function _init(param1:Array) : void
      {
         var _loc3_:ScaleBitmapImage = null;
         var _loc4_:FilterFrameText = null;
         var _loc5_:FilterFrameText = null;
         var _loc2_:int = 0;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText0");
            _loc4_.text = param1[_loc2_][0] as String;
            _loc4_.y = _loc4_.height * _loc2_ * 3 / 2;
            addChild(_loc4_);
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText1");
            _loc5_.text = param1[_loc2_][1] as String;
            _loc5_.y = _loc5_.height * _loc2_ * 3 / 2;
            addChild(_loc5_);
            _loc2_++;
         }
         this.oldHeight = height;
         _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionBG");
         addChild(_loc3_);
         _loc3_.x = this.BG_X;
         _loc3_.y = this.BG_Y;
         _loc3_.width = this.BG_WIDTH;
         _loc3_.height = this.height - this.BG_Y;
         setChildIndex(_loc3_,0);
      }
      
      public function get content() : Array
      {
         return this._arr;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
