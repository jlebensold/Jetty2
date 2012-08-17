window.Fixtures ?= {}
window.Fixtures.locale_tree = {
            name: "foo",
            children: [
                {
                 name: "bar",
                 children: [
                    {name: "baz"},
                    {name: "bad"},
                    {name: "bag"}
                 ]
                },
                {
                name: "World",
                children: [
                    {
                        name: "North America",
                        children: [
                            {
                                name: "Canada",
                                children: [
                                    {
                                        name: "Quebec",
                                        children: [
                                            {name:"Montreal"},
                                            {name:"Quebec City"},
                                            {name:"Hull"}
                                        ]
                                    },
                                    {
                                        name: "Ontario",
                                        children: [
                                            {name:"Toronto"}
                                            {name:"Ottawa"}
                                        ]
                                    }
                                ]
                            }
                        ]
                    }
                    {name: "South America"},
                    {name: "Middle East"},
                    {name: "Europe"},
                    {name: "Asia"},
                    {name: "Oceania"},
                    {name: "Africa"}
                ]
                }
             ]
            }