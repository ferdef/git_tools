Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$action,
    [Parameter(Mandatory=$True, Position=2)]
    [string]$issue
)

function LookUpBranches($issue) {
    $a = git branch -a | Where{$_ -like "*$issue*" }
    $new_list = @()
    ForEach ($item in $a) {
        $new_list += $item.Remove(0,2)
    }
    return ,$new_list
}

function CreateBranch($issue) {
    "Creating a Branch for issue $issue"
    $message = Read-Host("Branch Name: ")
    git checkout -b "$message_$issue"
}

function RemoveBranches($issue) {
    "Removing Branches"
    $selected_branch = SelectBranch($issue)
    git branch -D $selected_branch
}

function CheckoutBranches($issue) {
    "Activating Branches"
    $selected_branch = SelectBranch($issue)
    git checkout $selected_branch
}

function SelectBranch($issue) {
    $branches = LookUpBranches($issue)
    switch($branches.count) {
        0 { Write-Host "No branches with issue $issue"; exit }
        1 { $selected_branch = $branches[0]}
        default {
            $counter = 0
            foreach ($item in $branches) {
                $counter++
                Write-Host("$counter $item")
                $selected_branch = $branches[0]
            }
        }
    }
    $selected_branch
}

switch ($action) {
    "create" { CreateBranch($issue) }
    "remove" { RemoveBranches($issue) }
    "checkout" { CheckoutBranches($issue) }
    default { "No Valid Action" }
}