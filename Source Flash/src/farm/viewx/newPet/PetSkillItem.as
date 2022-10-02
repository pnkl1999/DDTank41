package farm.viewx.newPet
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import flash.display.Shape;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.view.item.SkillItem;
   
   public class PetSkillItem extends SkillItem
   {
       
      
      public function PetSkillItem(param1:PetSkillTemplateInfo, param2:int)
      {
         super(param1,param2,false,false);
      }
      
      override protected function initView() : void
      {
         _bg = ComponentFactory.Instance.creatCustomObject("farm.skillItemBG");
         addChild(_bg);
         tipDirctions = "5,2,7,1,6,4";
         tipGapH = 20;
         tipGapV = 20;
         graphics.beginFill(16711680,0);
         graphics.drawCircle(17.5,17.5,17);
         graphics.endFill();
         _mask = new Shape();
         _mask.graphics.beginFill(16711680,0);
         _mask.graphics.drawCircle(17.5,17.5,17);
         _mask.graphics.endFill();
         _mask.visible = !_canDrag;
         this.buttonMode = true;
         if(_info)
         {
            _skillIcon = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(_info.Pic));
            addChild(_skillIcon);
            this.updateSize();
         }
      }
      
      override public function updateSize() : void
      {
         if(_skillIcon)
         {
            _skillIcon.x = _iconPos.x;
            _skillIcon.y = _iconPos.y;
            _skillIcon.scaleX = _skillIcon.scaleY = SkillItem.ZOOMVALUE;
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
