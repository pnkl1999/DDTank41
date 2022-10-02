package farm.viewx.newPet
{
   import com.pickgliss.ui.ComponentFactory;
   import pet.date.PetInfo;
   import petsBag.view.item.AdoptItem;
   
   public class NewPetShowItem extends AdoptItem
   {
       
      
      public function NewPetShowItem(param1:PetInfo)
      {
         super(param1);
      }
      
      override protected function initView() : void
      {
         this.buttonMode = true;
         if(_info && _info.StarLevel == 4)
         {
            _bg = ComponentFactory.Instance.creatBitmap("assets.farm.unSelectpetPnlBgFourStar");
            addChild(_bg);
         }
         else
         {
            _bg = ComponentFactory.Instance.creatBitmap("assets.farm.petPnlBg");
            addChild(_bg);
         }
         if(_info)
         {
            _petMovieItem = ComponentFactory.Instance.creat("petsBag.petMovieItem");
            _petMovieItem.scaleY = 0.7;
            _petMovieItem.scaleX = 0.7;
            _petMovieItem.x = 45;
            _petMovieItem.y = 68;
            _petMovieItem.info = _info;
            addChild(_petMovieItem);
            _star = ComponentFactory.Instance.creat("farm.starBar.petStar");
            addChild(_star);
            _star.starNum(_info.StarLevel,"assets.farm.star");
         }
      }
      
      override protected function initEvent() : void
      {
      }
      
      override protected function removeEvent() : void
      {
      }
   }
}
