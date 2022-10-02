package ddt.view.academyCommon.myAcademy.myAcademyItem
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   
   public class MyAcademyClassmateItem extends MyAcademyMasterItem implements Disposeable
   {
       
      
      public function MyAcademyClassmateItem()
      {
         super();
      }
      
      override protected function initComponent() : void
      {
         _removeBtn.visible = false;
         _addFriend.visible = true;
         _stateTxt.visible = true;
         PositionUtils.setPos(_stateTxt,"academyCommon.myAcademy.MyAcademyClassmateItem.stateTxt");
         PositionUtils.setPos(_levelIcon,"academyCommon.myAcademy.MyAcademyClassmateItem.levelIcon");
         PositionUtils.setPos(_sexIcon,"academyCommon.myAcademy.MyAcademyClassmateItem.SexIcon");
         PositionUtils.setPos(_addFriend,"academyCommon.myAcademy.MyAcademyClassmateItem.addFriend");
      }
   }
}
