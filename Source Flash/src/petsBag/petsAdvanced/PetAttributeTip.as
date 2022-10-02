package petsBag.petsAdvanced
{
   import ddt.manager.LanguageMgr;
   import petsBag.view.item.PetGrowUpTip;
   
   public class PetAttributeTip extends PetGrowUpTip
   {
       
      
      public function PetAttributeTip()
      {
         super();
      }
      
      override protected function updateView() : void
      {
         _name.text = LanguageMgr.GetTranslation("ddt.petsBag.eatPets.tipsNameLv",_info.Name,String(_info.Level));
         _attackTxt.text = String(_info.Attack);
         _defenceTxt.text = String(_info.Defence);
         _agilityTxt.text = String(_info.Agility);
         _luckTxt.text = String(_info.Luck);
         _HPTxt.text = String(_info.Blood);
         fixPos();
         _bg.width = _container.width + 10;
         _bg.height = _container.height + 20;
         _width = _bg.width;
         _height = _bg.height;
      }
   }
}
