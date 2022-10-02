package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import pet.date.PetInfo;
   import petsBag.view.item.PetSmallItem;
   
   public class PetsEatSmallItem extends PetSmallItem implements Disposeable
   {
       
      
      private var starMc:MovieClip;
      
      public function PetsEatSmallItem(param1:PetInfo = null)
      {
         super(param1);
      }
      
      public function initTips() : void
      {
         tipStyle = "petsBag.petsAdvanced.PetAttributeTip";
         tipDirctions = "6";
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.starMc = ComponentFactory.Instance.creat("assets.PetsBag.eatPets.starMc");
         this.starMc.x = 31;
         this.starMc.y = 67;
         addChild(this.starMc);
         this.starMc.gotoAndStop(1);
      }
      
      override public function set info(param1:PetInfo) : void
      {
         super.info = param1;
         tipData = param1;
         this.starMc.gotoAndStop(_info.StarLevel);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.starMc)
         {
            ObjectUtils.disposeObject(this.starMc);
            this.starMc = null;
         }
      }
   }
}
