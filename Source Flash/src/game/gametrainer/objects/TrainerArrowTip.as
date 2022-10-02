package game.gametrainer.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.MovieClip;
   import phy.object.PhysicalObj;
   
   public class TrainerArrowTip extends PhysicalObj
   {
       
      
      private var _bannerAsset:MovieClip;
      
      public function TrainerArrowTip(param1:int, param2:int = 1, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 1)
      {
         super(param1,param2,param3,param4,param5,param6);
         this.init();
      }
      
      private function init() : void
      {
         this._bannerAsset = ComponentFactory.Instance.creat("asset.trainer.TrainerArrowAsset");
         this.addChild(this._bannerAsset);
      }
      
      public function gotoAndStopII(param1:int) : void
      {
         if(this._bannerAsset)
         {
            this._bannerAsset.gotoAndStop(param1);
         }
      }
      
      override public function dispose() : void
      {
         if(this._bannerAsset)
         {
            if(this._bannerAsset.parent)
            {
               this._bannerAsset.parent.removeChild(this._bannerAsset);
            }
         }
         this._bannerAsset = null;
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
