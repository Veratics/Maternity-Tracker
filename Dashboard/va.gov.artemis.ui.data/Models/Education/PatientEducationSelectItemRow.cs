﻿// Originally submitted to OSEHRA 2/21/2017 by DSS, Inc. 
// Authored by DSS, Inc. 2014-2017

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VA.Gov.Artemis.UI.Data.Models.Education
{
    public class PatientEducationSelectItemRow
    {
        public bool CategoryRow { get; set; }
        public string Ien { get; set; }
        public string Category { get; set; }
        public EducationItemType ItemType { get; set; }
        public string ItemTypeDescription { get; set; }
        public string Description { get; set; }
    }
}
