package effortView.movieClip
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class EffortHonorMovieClipView extends EffortMovieClipView
   {
      
      public static const HONOR_MAX_FRAME:int = 59;
       
      
      public function EffortHonorMovieClipView(param1:EffortInfo)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         var _loc2_:Point = null;
         this.buttonMode = true;
         this.mouseChildren = true;
         this.mouseEnabled = true;
         _movieClipView = ComponentFactory.Instance.creat("asset.Effort.honorEffortMovieClipAsset");
         addChild(_movieClipView);
         var _loc1_:int = 0;
         while(_loc1_ < _info.effortRewardArray.length)
         {
            if((_info.effortRewardArray[_loc1_] as EffortRewardInfo).RewardType == 1)
            {
               _movieClipView.honorText.text = EffortManager.Instance.splitTitle((_info.effortRewardArray[_loc1_] as EffortRewardInfo).RewardPara);
            }
            _loc1_++;
         }
         _movieClipView.honorText.mouseEnabled = false;
         _loc2_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortMovieClipView.EffortMovieClipViewPos");
         _movieClipView.x = _loc2_.x;
         _movieClipView.y = _loc2_.y;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
         _movieClipView.play();
         SoundManager.instance.play("121");
      }
      
      override protected function __cartoonFrameHandler(param1:Event) : void
      {
         if(!_movieClipView)
         {
            return;
         }
         if(_movieClipView.currentFrame <= HONOR_MAX_FRAME)
         {
            this.setAlpha();
         }
         if(_movieClipView.currentFrame == _movieClipView.totalFrames)
         {
            end();
            dispatchEvent(new Event(MOVIE_END));
         }
      }
      
      override protected function setAlpha() : void
      {
         if(_movieClipView.currentFrame <= ALPHA_FRAME)
         {
            _movieClipView.honorText.alpha = alphaArray[_movieClipView.currentFrame];
         }
         else
         {
            _movieClipView.honorText.alpha = 1;
         }
      }
   }
}
