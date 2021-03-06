﻿// Originally submitted to OSEHRA 2/21/2017 by DSS, Inc. 
// Authored by DSS, Inc. 2014-2017

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace VA.Gov.Artemis.UI.Data.Models.Text4Baby
{
    public class Text4BabyResult
    {
        [XmlElement(ElementName="customertype")]
        public string CustomerType { get; set; }

        [XmlElement(ElementName="participantid")]
        public string ParticipantId { get; set; }
    }
}
