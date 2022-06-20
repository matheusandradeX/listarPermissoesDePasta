$global:dados =""

# main form declaration 
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Listar Permissões de pasta'
$main_form.Width = 670
$main_form.Height = 150
$main_form.BackColor = "white"
$main_form.MaximizeBox = $false
$main_form.FormBorderStyle = 'Fixed3D'

# label text 1 
$text1 = New-Object System.Windows.Forms.label
$text1.Location = New-Object System.Drawing.Size(7,10)
$text1.Size = New-Object System.Drawing.Size(270,15)
$text1.ForeColor = "black"
$text1.Text = "Digite o caminho completa da pasta de rede ex: (S:\)"

# input folder patch 
$TextBoxPatch = New-Object System.Windows.Forms.TextBox
$TextBoxPatch.Location = '10,30'
$TextBoxPatch.Size = '500,500'

# label text2
$text2 = New-Object System.Windows.Forms.label
$text2.Location = New-Object System.Drawing.Size(7,55)
$text2.Size = New-Object System.Drawing.Size(270,15)
$text2.ForeColor = "black"
$text2.Text = "Permissões da pasta:"

# output folder permissions
$DropDownBox = New-Object System.Windows.Forms.ComboBox #creating the dropdown list
$DropDownBox.Location = New-Object System.Drawing.Size(10,75) #location of the drop down (px) in relation to the primary window's edges (length, height)
$DropDownBox.Size = New-Object System.Drawing.Size(500,20) #the size in px of the drop down box (length, height)
$DropDownBox.DropDownHeight = 100 #the height of the pop out selection box

# search button declaration
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(530,28)
$Button.Size = New-Object System.Drawing.Size(120,25)
$Button.Text = "Buscar"
$Button.Add_Click($Button_Click)
$Button_Click= {searchFunction}

function searchFunction {
$path = $TextBoxPatch.Text

if($global:dados -eq $path){
}
else{
$DropDownBox.Items.Clear()

$dados = ForEach-Object {(get-acl "$path").access }
foreach ($dado in $dados) {

$DropDownBox.Items.Add($dado.IdentityReference) 
} 
$global:dados=$path

}
}

# copy button declaration
$ButtonCopy = New-Object System.Windows.Forms.Button
$ButtonCopy.Location = New-Object System.Drawing.Size(530,75)
$ButtonCopy.Size = New-Object System.Drawing.Size(120,25)
$ButtonCopy.Text = "Copiar Clipboard"
$ButtonCopy.Add_Click($Button_Click2)
$Button_Click2= {copyFunction}

function copyFunction {

 $dados=$DropDownBox.SelectedItem.ToString()
 [System.Windows.MessageBox]::Show('Permissão de pasta copiada! '+$dados,'Listar Permissões de pasta')
 Set-Clipboard -Value $dados

}

#import elements to form
$main_form.Controls.Add($text1)
$main_form.Controls.Add($TextBoxPatch)
$main_form.Controls.Add($DropDownBox)
$main_form.Controls.Add($text2)
$main_form.Controls.Add($Button)
$main_form.Controls.Add($ButtonCopy)

#show program 
$main_form.ShowDialog()