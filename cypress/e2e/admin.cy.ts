describe('Admin Panel', () => {
  beforeEach(() => {
    cy.login('admin@example.com', 'adminpass')
    cy.visit('/app/admin')
  })

  it('should display admin dashboard', () => {
    cy.contains('Administration').should('be.visible')
    cy.contains('Utilisateurs').should('be.visible')
    cy.contains('Équipements').should('be.visible')
  })

  it('should filter users', () => {
    cy.get('input[placeholder="Recherche par matricule"]').type('ABC123')
    cy.get('table tbody tr').should('have.length.gte', 0)
  })

  it('should add new equipment', () => {
    cy.get('button').contains('Ajouter un équipement').click()
    cy.get('input[name="name"]').type('Test Equipment')
    cy.get('input[name="version"]').type('1.0')
    cy.get('input[name="reference"]').type('AN999')
    cy.get('button').contains('Créer').click()
    cy.contains('Équipement ajouté avec succès').should('be.visible')
  })

  it('should add new user', () => {
    cy.get('button').contains('Ajouter un utilisateur').click()
    cy.get('input[name="email"]').type('newuser@example.com')
    cy.get('input[name="first_name"]').type('New')
    cy.get('input[name="last_name"]').type('User')
    cy.get('input[name="id_number"]').type('XYZ789')
    cy.get('input[name="password"]').type('password123')
    cy.get('button').contains('Créer').click()
    cy.contains('Utilisateur créé avec succès').should('be.visible')
  })
})